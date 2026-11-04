-- Schema consolidado até 20261102220150. Uso exclusivo em banco vazio.
-- Inclui tabelas, índices, constraints, funções, triggers, RLS e permissões.
-- Requer os papéis anon, authenticated e service_role. Executar seed.sql depois.
BEGIN;

SET LOCAL statement_timeout = 0;
SET LOCAL lock_timeout = 0;
SET LOCAL idle_in_transaction_session_timeout = 0;
SET LOCAL transaction_timeout = 0;
SET LOCAL client_encoding = 'UTF8';
SET LOCAL standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', true);
SET LOCAL check_function_bodies = false;
SET LOCAL xmloption = content;
SET LOCAL client_min_messages = warning;
SET LOCAL row_security = off;

CREATE FUNCTION public.alterar_senha_segura(p_usuario integer, p_hash_atual text, p_hash_novo text) RETURNS boolean
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  UPDATE public.usuarios SET senha_hash = p_hash_novo, versao_sessao = versao_sessao + 1
  WHERE idusuarios = p_usuario AND senha_hash = p_hash_atual;
  RETURN FOUND;
END;
$$;

CREATE FUNCTION public.congelar_gabarito_continuidade() RETURNS trigger
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  -- Compatibilidade com respostas gravadas pelas rotas originais da develop.
  IF NEW.respondido_em IS NOT NULL AND NEW.resposta_escolhida IS NOT NULL THEN NEW.respondida := true; END IF;
  IF NOT OLD.respondida AND NEW.respondida AND NEW.resposta_correta IS NULL THEN
    SELECT letra INTO NEW.resposta_correta FROM public.alternativas
      WHERE questoes_idquestoes=NEW.questoes_idquestoes AND correta LIMIT 1;
  END IF;
  RETURN NEW;
END;
$$;

CREATE FUNCTION public.finalizar_prova(p_usuario integer, p_tentativa integer) RETURNS jsonb
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  tentativa public.tentativas;
  certificado public.certificados;
  total INTEGER;
  temas INTEGER;
  pendentes INTEGER;
  v_acertos INTEGER;
  v_percentual NUMERIC(5,2);
BEGIN
  SELECT * INTO tentativa FROM public.tentativas
    WHERE idtentativas=p_tentativa AND usuarios_idusuarios=p_usuario FOR UPDATE;
  IF NOT FOUND THEN RETURN jsonb_build_object('erro_codigo','NAO_ENCONTRADA'); END IF;
  IF tentativa.status NOT IN ('EM_ANDAMENTO','FINALIZADA') THEN RETURN jsonb_build_object('erro_codigo','INDISPONIVEL'); END IF;
  UPDATE public.tentativas_questoes SET respondida=true,expirou=true,acertou=false,respondido_em=clock_timestamp()
    WHERE tentativas_idtentativas=p_tentativa AND NOT respondida AND expira_em<=clock_timestamp();
  SELECT count(*),count(DISTINCT q.temas_idtemas),count(*) FILTER (WHERE NOT tq.respondida),count(*) FILTER (WHERE tq.acertou AND NOT tq.expirou)
    INTO total,temas,pendentes,v_acertos FROM public.tentativas_questoes tq
    JOIN public.questoes q ON q.idquestoes=tq.questoes_idquestoes
    WHERE tq.tentativas_idtentativas=p_tentativa AND tq.ordem IS NOT NULL;
  IF total<>12 OR temas<>12 THEN RETURN jsonb_build_object('erro_codigo','PROVA_INVALIDA'); END IF;
  IF pendentes>0 THEN RETURN jsonb_build_object('erro_codigo','PENDENTE'); END IF;
  IF tentativa.status='EM_ANDAMENTO' THEN
    v_percentual := round(v_acertos*100.0/12,2);
    UPDATE public.tentativas SET finalizado_em=clock_timestamp(),status='FINALIZADA',acertos=v_acertos,
      percentual=v_percentual,aprovado=(v_percentual>=65)
      WHERE idtentativas=p_tentativa RETURNING * INTO tentativa;
    IF tentativa.aprovado THEN
      INSERT INTO public.certificados(usuarios_idusuarios,tentativas_idtentativas,score,percentual,ativo)
        VALUES(p_usuario,p_tentativa,tentativa.acertos,tentativa.percentual,true) RETURNING * INTO certificado;
    END IF;
  ELSE
    SELECT * INTO certificado FROM public.certificados WHERE tentativas_idtentativas=p_tentativa;
  END IF;
  RETURN jsonb_build_object('tentativa',to_jsonb(tentativa),
    'resultado',jsonb_build_object('total',12,'acertos',tentativa.acertos,'percentual',tentativa.percentual,'aprovado',tentativa.aprovado),
    'certificado',CASE WHEN certificado.idcertificados IS NULL THEN NULL ELSE to_jsonb(certificado) END);
END;
$$;

CREATE FUNCTION public.iniciar_prova(p_usuario integer) RETURNS jsonb
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  escolhidas INTEGER[];
  tentativa public.tentativas;
BEGIN
  -- Uma única fotografia da base: exatamente 12 temas ativos, cada um com
  -- quatro questões publicadas e estruturalmente válidas (4 alternativas/1 correta).
  WITH elegiveis AS (
    SELECT q.idquestoes, q.temas_idtemas FROM public.questoes q
    WHERE q.status AND q.status_editorial='APROVADO'
      AND (SELECT count(*)=4 AND count(*) FILTER (WHERE a.correta)=1
           FROM public.alternativas a WHERE a.questoes_idquestoes=q.idquestoes)
  ), catalogo AS (
    SELECT t.idtemas, t.ordem,
      (SELECT count(*) FROM elegiveis e WHERE e.temas_idtemas=t.idtemas) quantidade,
      (SELECT e.idquestoes FROM elegiveis e WHERE e.temas_idtemas=t.idtemas ORDER BY random() LIMIT 1) questao
    FROM public.temas t WHERE t.ativo
  )
  SELECT array_agg(questao ORDER BY ordem NULLS LAST,idtemas) INTO escolhidas FROM catalogo
  HAVING count(*)=12 AND min(quantidade)>=4;
  IF escolhidas IS NULL THEN
    RETURN jsonb_build_object('erro_codigo','BASE_INSUFICIENTE');
  END IF;
  INSERT INTO public.tentativas(usuarios_idusuarios,iniciado_em,status)
  VALUES(p_usuario,clock_timestamp(),'EM_ANDAMENTO') RETURNING * INTO tentativa;
  INSERT INTO public.tentativas_questoes(tentativas_idtentativas,questoes_idquestoes,ordem)
  SELECT tentativa.idtentativas,q,ord::INTEGER FROM unnest(escolhidas) WITH ORDINALITY AS x(q,ord);
  RETURN jsonb_build_object('tentativa',to_jsonb(tentativa),'total_questoes',12);
END;
$$;

CREATE FUNCTION public.limitar_autenticacao(p_ip text, p_conta text, p_cadastro boolean) RETURNS jsonb
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  chave_atual TEXT;
  registro public.limites_autenticacao;
  limite INTEGER;
  espera INTEGER := 0;
  agora TIMESTAMPTZ;
BEGIN
  -- Ordem estável evita deadlocks entre IP/conta em requisições concorrentes.
  FOREACH chave_atual IN ARRAY (SELECT array_agg(k ORDER BY k) FROM unnest(ARRAY[p_ip,p_conta]) k)
  LOOP
    agora := clock_timestamp();
    INSERT INTO public.limites_autenticacao(chave,inicio,tentativas) VALUES(chave_atual,agora,0)
    ON CONFLICT DO NOTHING;
    SELECT * INTO registro FROM public.limites_autenticacao WHERE chave=chave_atual FOR UPDATE;
    agora := clock_timestamp();
    IF registro.inicio + INTERVAL '15 minutes' <= agora THEN
      registro.inicio := agora;
      registro.tentativas := 0;
    END IF;
    limite := CASE WHEN p_cadastro THEN 10 WHEN chave_atual=p_ip THEN 30 ELSE 10 END;
    -- Satura o contador; chamadas bloqueadas não estendem a janela.
    registro.tentativas := least(registro.tentativas + 1, limite + 1);
    UPDATE public.limites_autenticacao SET inicio=registro.inicio,tentativas=registro.tentativas WHERE chave=chave_atual;
    IF registro.tentativas > limite THEN
      espera := greatest(espera, ceil(extract(epoch FROM registro.inicio + INTERVAL '15 minutes' - agora))::INTEGER, 1);
    END IF;
  END LOOP;
  -- Limpeza limitada, sem varrer/apagar todos os contadores a cada chamada.
  DELETE FROM public.limites_autenticacao WHERE chave IN (
    SELECT chave FROM public.limites_autenticacao WHERE inicio < clock_timestamp() - INTERVAL '1 day' LIMIT 100 FOR UPDATE SKIP LOCKED
  );
  RETURN jsonb_build_object('permitido', espera=0, 'retry_after', espera);
END;
$$;

CREATE FUNCTION public.operar_continuidade_prova(p_usuario integer, p_acao text, p_tentativa integer DEFAULT NULL::integer, p_sessao uuid DEFAULT NULL::uuid, p_questao integer DEFAULT NULL::integer, p_alternativa integer DEFAULT NULL::integer, p_motivo text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
BEGIN
  IF p_acao='iniciar' THEN
    PERFORM 1 FROM public.usuarios WHERE idusuarios=p_usuario FOR UPDATE;
    IF NOT FOUND THEN RETURN jsonb_build_object('erro_codigo','NAO_ENCONTRADA'); END IF;
    IF NOT EXISTS(SELECT 1 FROM public.tentativas WHERE usuarios_idusuarios=p_usuario AND status IN ('EM_ANDAMENTO','INTERROMPIDA'))
      AND (SELECT count(*) FROM public.progresso_estudos p JOIN public.temas t ON t.idtemas=p.temas_idtemas
        WHERE p.usuarios_idusuarios=p_usuario AND t.ativo)<>12 THEN
      RETURN jsonb_build_object('erro_codigo','ESTUDOS_PENDENTES');
    END IF;
  END IF;
  RETURN public.operar_continuidade_prova_base(p_usuario,p_acao,p_tentativa,p_sessao,p_questao,p_alternativa,p_motivo);
END;
$$;

CREATE FUNCTION public.operar_continuidade_prova_base(p_usuario integer, p_acao text, p_tentativa integer DEFAULT NULL::integer, p_sessao uuid DEFAULT NULL::uuid, p_questao integer DEFAULT NULL::integer, p_alternativa integer DEFAULT NULL::integer, p_motivo text DEFAULT NULL::text) RETURNS jsonb
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  t public.tentativas;
  q public.tentativas_questoes;
  resultado JSONB;
  motivo TEXT;
  agora TIMESTAMPTZ;
BEGIN
  IF p_acao NOT IN ('atual','iniciar','retomar','estado','proxima','presenca','responder','pausar','interromper','finalizar')
    OR (p_acao<>'atual' AND p_sessao IS NULL) THEN
    RETURN jsonb_build_object('erro_codigo','ACAO_INVALIDA');
  END IF;
  IF p_acao IN ('atual','iniciar') THEN
    -- Dois cliques em Iniciar não criam provas duplicadas.
    PERFORM 1 FROM public.usuarios WHERE idusuarios=p_usuario FOR UPDATE;
    IF NOT FOUND THEN RETURN jsonb_build_object('erro_codigo','NAO_ENCONTRADA'); END IF;
    SELECT * INTO t FROM public.tentativas WHERE usuarios_idusuarios=p_usuario
      AND status IN ('EM_ANDAMENTO','INTERROMPIDA') ORDER BY idtentativas DESC LIMIT 1 FOR UPDATE;
    IF p_acao='atual' THEN
      IF t.idtentativas IS NULL THEN RETURN jsonb_build_object('tentativa',NULL); END IF;
      RETURN public.resumo_continuidade_prova(p_usuario,t.idtentativas);
    END IF;
    IF t.idtentativas IS NULL THEN
      resultado := public.iniciar_prova(p_usuario);
      IF resultado ? 'erro_codigo' THEN RETURN resultado; END IF;
      SELECT * INTO t FROM public.tentativas
        WHERE idtentativas=(resultado->'tentativa'->>'idtentativas')::INTEGER FOR UPDATE;
    END IF;
  ELSE
    SELECT * INTO t FROM public.tentativas WHERE idtentativas=p_tentativa
      AND usuarios_idusuarios=p_usuario FOR UPDATE;
    IF NOT FOUND THEN RETURN jsonb_build_object('erro_codigo','NAO_ENCONTRADA'); END IF;
  END IF;

  IF (SELECT count(*) FROM public.tentativas_questoes WHERE tentativas_idtentativas=t.idtentativas AND ordem IS NOT NULL)<>12 THEN
    RETURN jsonb_build_object('erro_codigo','PROVA_INVALIDA');
  END IF;
  IF p_acao NOT IN ('iniciar','retomar') AND t.sessao_prova IS DISTINCT FROM p_sessao THEN
    RETURN jsonb_build_object('erro_codigo','SESSAO_INVALIDA');
  END IF;
  IF t.status='FINALIZADA' THEN
    IF p_acao IN ('finalizar','estado') THEN RETURN public.finalizar_prova(p_usuario,t.idtentativas); END IF;
    RETURN jsonb_build_object('erro_codigo','INDISPONIVEL');
  END IF;
  IF t.status NOT IN ('EM_ANDAMENTO','INTERROMPIDA') THEN
    RETURN jsonb_build_object('erro_codigo','INDISPONIVEL');
  END IF;

  agora := clock_timestamp();
  SELECT * INTO q FROM public.tentativas_questoes WHERE tentativas_idtentativas=t.idtentativas
    AND NOT respondida AND iniciado_em IS NOT NULL ORDER BY ordem LIMIT 1;
  IF q.questoes_idquestoes IS NOT NULL THEN
    -- Eventos de saída só podem encerrar a questão exata que originou o evento.
    IF p_acao='interromper' AND (p_questao IS DISTINCT FROM q.questoes_idquestoes OR p_motivo NOT IN ('CONEXAO','FECHAMENTO') OR p_motivo IS NULL) THEN
      RETURN jsonb_build_object('erro_codigo','ACAO_INVALIDA');
    END IF;
    motivo := CASE
      WHEN q.expira_em<=agora THEN 'TEMPO'
      WHEN p_acao IN ('iniciar','retomar') AND t.sessao_prova IS DISTINCT FROM p_sessao THEN 'RETOMADA'
      WHEN t.ultimo_contato_em IS NULL OR t.ultimo_contato_em+INTERVAL '30 seconds'<=agora THEN 'CONEXAO'
      WHEN p_acao='interromper' THEN p_motivo
      ELSE NULL END;
    IF motivo IS NOT NULL THEN
      UPDATE public.tentativas_questoes SET respondida=true,acertou=false,expirou=(motivo='TEMPO'),
        respondido_em=agora,motivo_encerramento=motivo
        WHERE tentativas_idtentativas=t.idtentativas AND questoes_idquestoes=q.questoes_idquestoes;
      IF motivo<>'TEMPO' THEN
        UPDATE public.tentativas SET status='INTERROMPIDA' WHERE idtentativas=t.idtentativas;
        t.status := 'INTERROMPIDA';
      END IF;
      IF p_acao='responder' THEN RETURN jsonb_build_object('erro_codigo','TEMPO_ESGOTADO'); END IF;
    END IF;
  END IF;

  IF p_acao IN ('iniciar','retomar') THEN
    UPDATE public.tentativas SET status='EM_ANDAMENTO',sessao_prova=p_sessao,ultimo_contato_em=agora
      WHERE idtentativas=t.idtentativas;
    RETURN public.resumo_continuidade_prova(p_usuario,t.idtentativas);
  END IF;
  IF p_acao='pausar' THEN
    IF EXISTS(SELECT 1 FROM public.tentativas_questoes WHERE tentativas_idtentativas=t.idtentativas AND iniciado_em IS NOT NULL AND NOT respondida) THEN
      RETURN jsonb_build_object('erro_codigo','QUESTAO_ABERTA');
    END IF;
    UPDATE public.tentativas SET status='INTERROMPIDA' WHERE idtentativas=t.idtentativas;
  ELSIF p_acao='interromper' THEN
    -- Sem questão aberta: chamada repetida/atrasada não altera a próxima questão.
    NULL;
  ELSIF p_acao='proxima' THEN
    IF t.status<>'EM_ANDAMENTO' THEN RETURN jsonb_build_object('erro_codigo','INDISPONIVEL'); END IF;
    UPDATE public.tentativas SET ultimo_contato_em=agora WHERE idtentativas=t.idtentativas;
    resultado := public.proxima_questao_segura(p_usuario,t.idtentativas);
    RETURN resultado || jsonb_build_object('agora',clock_timestamp());
  ELSIF p_acao='responder' THEN
    IF t.status<>'EM_ANDAMENTO' THEN RETURN jsonb_build_object('erro_codigo','INDISPONIVEL'); END IF;
    resultado := public.responder_prova(p_usuario,t.idtentativas,p_questao,p_alternativa);
    IF NOT (resultado ? 'erro_codigo') THEN
      UPDATE public.tentativas_questoes SET motivo_encerramento='RESPOSTA'
        WHERE tentativas_idtentativas=t.idtentativas AND questoes_idquestoes=p_questao;
    END IF;
    RETURN resultado;
  ELSIF p_acao='finalizar' THEN
    RETURN public.finalizar_prova(p_usuario,t.idtentativas);
  ELSIF p_acao='presenca' THEN
    -- Renovar presença nunca altera o prazo de 150 s da questão.
    UPDATE public.tentativas SET ultimo_contato_em=agora WHERE idtentativas=t.idtentativas;
  END IF;
  RETURN public.resumo_continuidade_prova(p_usuario,t.idtentativas);
END;
$$;

CREATE FUNCTION public.proxima_questao_segura(p_usuario integer, p_tentativa integer) RETURNS jsonb
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  tentativa public.tentativas;
  atual public.tentativas_questoes;
  questao JSONB;
  alternativas JSONB;
  agora TIMESTAMPTZ;
BEGIN
  SELECT * INTO tentativa FROM public.tentativas
    WHERE idtentativas=p_tentativa AND usuarios_idusuarios=p_usuario FOR UPDATE;
  IF NOT FOUND THEN RETURN jsonb_build_object('erro_codigo','NAO_ENCONTRADA'); END IF;
  IF tentativa.status <> 'EM_ANDAMENTO' THEN RETURN jsonb_build_object('erro_codigo','INDISPONIVEL'); END IF;
  IF (SELECT count(*) FROM public.tentativas_questoes WHERE tentativas_idtentativas=p_tentativa AND ordem IS NOT NULL) <> 12 THEN
    RETURN jsonb_build_object('erro_codigo','PROVA_INVALIDA');
  END IF;
  LOOP
    SELECT * INTO atual FROM public.tentativas_questoes
      WHERE tentativas_idtentativas=p_tentativa AND NOT respondida ORDER BY ordem LIMIT 1;
    IF NOT FOUND THEN RETURN jsonb_build_object('concluida',true); END IF;
    agora := clock_timestamp();
    EXIT WHEN atual.expira_em IS NULL OR agora < atual.expira_em;
    UPDATE public.tentativas_questoes SET respondida=true,expirou=true,acertou=false,respondido_em=agora
      WHERE tentativas_idtentativas=p_tentativa AND questoes_idquestoes=atual.questoes_idquestoes;
  END LOOP;
  -- Desativação editorial durante uma prova também bloqueia nova entrega.
  SELECT jsonb_build_object('idquestoes',q.idquestoes,'temas_idtemas',q.temas_idtemas,
    'enunciado',q.enunciado,'imagem_url',q.imagem_url) INTO questao
    FROM public.questoes q JOIN public.temas t ON t.idtemas=q.temas_idtemas
    WHERE q.idquestoes=atual.questoes_idquestoes AND q.status AND q.status_editorial='APROVADO' AND t.ativo;
  SELECT jsonb_agg(jsonb_build_object('idalternativas',a.idalternativas,'letra',a.letra,'texto',a.texto) ORDER BY a.letra)
    INTO alternativas FROM public.alternativas a WHERE a.questoes_idquestoes=atual.questoes_idquestoes
    HAVING count(*)=4 AND count(*) FILTER (WHERE a.correta)=1;
  IF questao IS NULL OR alternativas IS NULL THEN RETURN jsonb_build_object('erro_codigo','CONTEUDO_INDISPONIVEL'); END IF;
  IF atual.iniciado_em IS NULL THEN
    agora := clock_timestamp();
    UPDATE public.tentativas_questoes SET iniciado_em=agora, expira_em=agora+INTERVAL '150 seconds'
      WHERE tentativas_idtentativas=p_tentativa AND questoes_idquestoes=atual.questoes_idquestoes RETURNING * INTO atual;
  END IF;
  RETURN jsonb_build_object('concluida',false,'questao',questao,'alternativas',alternativas,
    'ordem',atual.ordem,'iniciado_em',atual.iniciado_em,'expira_em',atual.expira_em);
END;
$$;

CREATE FUNCTION public.responder_prova(p_usuario integer, p_tentativa integer, p_questao integer, p_alternativa integer) RETURNS jsonb
    LANGUAGE plpgsql
    SET search_path TO ''
    AS $$
DECLARE
  tentativa public.tentativas;
  atual public.tentativas_questoes;
  alternativa public.alternativas;
  resposta INTEGER;
  agora TIMESTAMPTZ;
BEGIN
  SELECT * INTO tentativa FROM public.tentativas
    WHERE idtentativas=p_tentativa AND usuarios_idusuarios=p_usuario FOR UPDATE;
  IF NOT FOUND THEN RETURN jsonb_build_object('erro_codigo','NAO_ENCONTRADA'); END IF;
  IF tentativa.status <> 'EM_ANDAMENTO' THEN RETURN jsonb_build_object('erro_codigo','INDISPONIVEL'); END IF;
  IF (SELECT count(*) FROM public.tentativas_questoes WHERE tentativas_idtentativas=p_tentativa AND ordem IS NOT NULL) <> 12 THEN
    RETURN jsonb_build_object('erro_codigo','PROVA_INVALIDA');
  END IF;
  SELECT * INTO atual FROM public.tentativas_questoes WHERE tentativas_idtentativas=p_tentativa AND NOT respondida ORDER BY ordem LIMIT 1;
  IF NOT FOUND OR atual.questoes_idquestoes <> p_questao OR atual.iniciado_em IS NULL THEN
    RETURN jsonb_build_object('erro_codigo','FORA_SEQUENCIA');
  END IF;
  agora := clock_timestamp();
  IF agora >= atual.expira_em THEN
    UPDATE public.tentativas_questoes SET respondida=true,expirou=true,acertou=false,respondido_em=agora
      WHERE tentativas_idtentativas=p_tentativa AND questoes_idquestoes=p_questao;
    -- Retorna erro de domínio sem RAISE para persistir o timeout.
    RETURN jsonb_build_object('erro_codigo','TEMPO_ESGOTADO');
  END IF;
  SELECT * INTO alternativa FROM public.alternativas WHERE idalternativas=p_alternativa AND questoes_idquestoes=p_questao;
  IF NOT FOUND THEN RETURN jsonb_build_object('erro_codigo','ALTERNATIVA_INVALIDA'); END IF;
  INSERT INTO public.respostas(tentativas_idtentativas,questoes_idquestoes,alternativas_idalternativas,correta,respondida_em)
    VALUES(p_tentativa,p_questao,p_alternativa,alternativa.correta,agora) RETURNING idrespostas INTO resposta;
  UPDATE public.tentativas_questoes SET respondida=true,acertou=alternativa.correta,resposta_escolhida=alternativa.letra,respondido_em=agora
    WHERE tentativas_idtentativas=p_tentativa AND questoes_idquestoes=p_questao;
  RETURN jsonb_build_object('resposta_registrada',true,'id',resposta);
END;
$$;

CREATE FUNCTION public.resumo_continuidade_prova(p_usuario integer, p_tentativa integer) RETURNS jsonb
    LANGUAGE sql
    SET search_path TO ''
    AS $$
  SELECT jsonb_build_object(
    'tentativa', jsonb_build_object('idtentativas',t.idtentativas,'status',t.status,
      'iniciado_em',t.iniciado_em,'acertos',t.acertos,'percentual',t.percentual,'aprovado',t.aprovado),
    'total_questoes',count(q.questoes_idquestoes),
    'respondidas',count(*) FILTER (WHERE q.respondida),
    'pendentes',count(*) FILTER (WHERE NOT q.respondida),
    'questao_aberta',(SELECT jsonb_build_object('idquestoes',a.questoes_idquestoes,'ordem',a.ordem,'expira_em',a.expira_em)
      FROM public.tentativas_questoes a WHERE a.tentativas_idtentativas=t.idtentativas
      AND NOT a.respondida AND a.iniciado_em IS NOT NULL ORDER BY a.ordem LIMIT 1),
    'agora',clock_timestamp())
  FROM public.tentativas t LEFT JOIN public.tentativas_questoes q ON q.tentativas_idtentativas=t.idtentativas
  WHERE t.idtentativas=p_tentativa AND t.usuarios_idusuarios=p_usuario GROUP BY t.idtentativas;
$$;

SET LOCAL default_tablespace = '';

SET LOCAL default_table_access_method = heap;

CREATE TABLE public.alternativas (
    idalternativas integer NOT NULL,
    questoes_idquestoes integer NOT NULL,
    letra character(1) NOT NULL,
    texto character varying(200) NOT NULL,
    correta boolean DEFAULT false,
    CONSTRAINT ck_alternativa_letra CHECK ((letra = ANY (ARRAY['A'::bpchar, 'B'::bpchar, 'C'::bpchar, 'D'::bpchar])))
);

ALTER TABLE public.alternativas ALTER COLUMN idalternativas ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.alternativas_idalternativas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.certificados (
    idcertificados integer NOT NULL,
    usuarios_idusuarios integer NOT NULL,
    emitido_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    score integer,
    percentual numeric(5,2),
    ativo boolean DEFAULT true,
    revogado_em timestamp without time zone,
    codigo_validacao uuid DEFAULT gen_random_uuid(),
    tentativas_idtentativas integer,
    CONSTRAINT ck_certificados_percentual CHECK (((percentual >= (0)::numeric) AND (percentual <= (100)::numeric))),
    CONSTRAINT ck_certificados_score CHECK ((score >= 0))
);

ALTER TABLE public.certificados ALTER COLUMN idcertificados ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.certificados_idcertificados_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.conteudos (
    idconteudo integer NOT NULL,
    temas_idtemas integer NOT NULL,
    titulo text,
    descricao text,
    status boolean DEFAULT true,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    recurso_url text,
    codigo_seed text
);

ALTER TABLE public.conteudos ALTER COLUMN idconteudo ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.conteudos_idconteudo_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.limites_autenticacao (
    chave text NOT NULL,
    inicio timestamp with time zone NOT NULL,
    tentativas integer NOT NULL,
    CONSTRAINT limites_autenticacao_chave_check CHECK ((length(chave) = 64))
);

CREATE TABLE public.progresso_estudos (
    usuarios_idusuarios integer NOT NULL,
    temas_idtemas integer NOT NULL,
    concluido_em timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);

CREATE TABLE public.questoes (
    idquestoes integer NOT NULL,
    temas_idtemas integer NOT NULL,
    enunciado character varying(400) NOT NULL,
    imagem_url character varying(500),
    status boolean DEFAULT true,
    codigo_seed text,
    status_editorial text DEFAULT 'RASCUNHO'::text NOT NULL,
    imagem_alt text,
    CONSTRAINT questoes_status_editorial_check CHECK ((status_editorial = ANY (ARRAY['RASCUNHO'::text, 'REVISAO'::text, 'APROVADO'::text])))
);

ALTER TABLE public.questoes ALTER COLUMN idquestoes ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.questoes_idquestoes_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.respostas (
    idrespostas integer NOT NULL,
    tentativas_idtentativas integer NOT NULL,
    questoes_idquestoes integer NOT NULL,
    alternativas_idalternativas integer NOT NULL,
    correta boolean NOT NULL,
    respondida_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE public.respostas ALTER COLUMN idrespostas ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.respostas_idrespostas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.sessoes_revogadas (
    token_hash text NOT NULL,
    expira_em timestamp with time zone NOT NULL,
    revogado_em timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT sessoes_revogadas_token_hash_check CHECK ((length(token_hash) = 64))
);

CREATE TABLE public.temas (
    idtemas integer NOT NULL,
    nome character varying(100) NOT NULL,
    descricao character varying(255),
    ordem integer,
    ativo boolean DEFAULT true
);

ALTER TABLE public.temas ALTER COLUMN idtemas ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.temas_idtemas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.tentativas (
    idtentativas integer NOT NULL,
    usuarios_idusuarios integer NOT NULL,
    iniciado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    expira_em timestamp without time zone,
    finalizado_em timestamp without time zone,
    status character varying(20) DEFAULT 'EM_ANDAMENTO'::character varying,
    acertos integer DEFAULT 0,
    percentual numeric(5,2) DEFAULT 0.00,
    aprovado boolean DEFAULT false,
    sessao_prova uuid,
    ultimo_contato_em timestamp with time zone,
    CONSTRAINT ck_tentativas_acertos CHECK ((acertos >= 0)),
    CONSTRAINT ck_tentativas_percentual CHECK (((percentual >= (0)::numeric) AND (percentual <= (100)::numeric)))
);

ALTER TABLE public.tentativas ALTER COLUMN idtentativas ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.tentativas_idtentativas_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

CREATE TABLE public.tentativas_questoes (
    tentativas_idtentativas integer NOT NULL,
    questoes_idquestoes integer NOT NULL,
    respondida boolean DEFAULT false NOT NULL,
    resposta_escolhida character(1),
    acertou boolean DEFAULT false,
    respondido_em timestamp without time zone,
    ordem integer,
    iniciado_em timestamp with time zone,
    expira_em timestamp with time zone,
    expirou boolean DEFAULT false NOT NULL,
    resposta_correta character(1),
    motivo_encerramento text,
    CONSTRAINT tentativas_questoes_motivo_encerramento_check CHECK ((motivo_encerramento = ANY (ARRAY['RESPOSTA'::text, 'TEMPO'::text, 'CONEXAO'::text, 'FECHAMENTO'::text, 'RETOMADA'::text]))),
    CONSTRAINT tentativas_questoes_ordem_check CHECK (((ordem >= 1) AND (ordem <= 12)))
);

CREATE TABLE public.usuarios (
    idusuarios integer NOT NULL,
    cpf character(11) NOT NULL,
    nome character varying(50) NOT NULL,
    email text NOT NULL,
    senha_hash character varying(100) NOT NULL,
    criado_em timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    versao_sessao integer DEFAULT 0 NOT NULL
);

ALTER TABLE public.usuarios ALTER COLUMN idusuarios ADD GENERATED ALWAYS AS IDENTITY (
    SEQUENCE NAME public.usuarios_idusuarios_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);

ALTER TABLE ONLY public.conteudos
    ADD CONSTRAINT conteudos_codigo_seed_key UNIQUE (codigo_seed);

ALTER TABLE ONLY public.limites_autenticacao
    ADD CONSTRAINT limites_autenticacao_pkey PRIMARY KEY (chave);

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT pk_alternativas PRIMARY KEY (idalternativas);

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT pk_certificados PRIMARY KEY (idcertificados);

ALTER TABLE ONLY public.conteudos
    ADD CONSTRAINT pk_conteudos PRIMARY KEY (idconteudo);

ALTER TABLE ONLY public.questoes
    ADD CONSTRAINT pk_questoes PRIMARY KEY (idquestoes);

ALTER TABLE ONLY public.temas
    ADD CONSTRAINT pk_temas PRIMARY KEY (idtemas);

ALTER TABLE ONLY public.tentativas
    ADD CONSTRAINT pk_tentativas PRIMARY KEY (idtentativas);

ALTER TABLE ONLY public.tentativas_questoes
    ADD CONSTRAINT pk_tentativas_questoes PRIMARY KEY (tentativas_idtentativas, questoes_idquestoes);

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT pk_usuarios PRIMARY KEY (idusuarios);

ALTER TABLE ONLY public.progresso_estudos
    ADD CONSTRAINT progresso_estudos_pkey PRIMARY KEY (usuarios_idusuarios, temas_idtemas);

ALTER TABLE ONLY public.questoes
    ADD CONSTRAINT questoes_codigo_seed_key UNIQUE (codigo_seed);

ALTER TABLE ONLY public.respostas
    ADD CONSTRAINT respostas_pkey PRIMARY KEY (idrespostas);

ALTER TABLE ONLY public.respostas
    ADD CONSTRAINT respostas_tentativas_idtentativas_questoes_idquestoes_key UNIQUE (tentativas_idtentativas, questoes_idquestoes);

ALTER TABLE ONLY public.sessoes_revogadas
    ADD CONSTRAINT sessoes_revogadas_pkey PRIMARY KEY (token_hash);

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT uq_alternativas_letra_questao UNIQUE (questoes_idquestoes, letra);

ALTER TABLE ONLY public.temas
    ADD CONSTRAINT uq_temas_nome UNIQUE (nome);

ALTER TABLE ONLY public.usuarios
    ADD CONSTRAINT uq_usuarios_cpf UNIQUE (cpf);

CREATE UNIQUE INDEX certificados_codigo_validacao_uq ON public.certificados USING btree (codigo_validacao);

CREATE UNIQUE INDEX certificados_tentativa_uq ON public.certificados USING btree (tentativas_idtentativas);

CREATE INDEX idx_alternativas_questoes ON public.alternativas USING btree (questoes_idquestoes);

CREATE INDEX idx_certificados_usuarios ON public.certificados USING btree (usuarios_idusuarios);

CREATE INDEX idx_conteudos_temas ON public.conteudos USING btree (temas_idtemas);

CREATE INDEX idx_questoes_temas ON public.questoes USING btree (temas_idtemas);

CREATE INDEX idx_sessoes_revogadas_expira ON public.sessoes_revogadas USING btree (expira_em);

CREATE INDEX idx_tentativas_questoes_questao ON public.tentativas_questoes USING btree (questoes_idquestoes);

CREATE INDEX idx_tentativas_questoes_tentativa ON public.tentativas_questoes USING btree (tentativas_idtentativas);

CREATE INDEX idx_tentativas_usuarios ON public.tentativas USING btree (usuarios_idusuarios);

CREATE INDEX limites_autenticacao_inicio_idx ON public.limites_autenticacao USING btree (inicio);

CREATE UNIQUE INDEX tentativas_ordem_uq ON public.tentativas_questoes USING btree (tentativas_idtentativas, ordem);

CREATE UNIQUE INDEX uq_alternativa_correta ON public.alternativas USING btree (questoes_idquestoes) WHERE correta;

CREATE TRIGGER congelar_gabarito_continuidade BEFORE UPDATE ON public.tentativas_questoes FOR EACH ROW EXECUTE FUNCTION public.congelar_gabarito_continuidade();

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT certificados_tentativas_idtentativas_fkey FOREIGN KEY (tentativas_idtentativas) REFERENCES public.tentativas(idtentativas);

ALTER TABLE ONLY public.alternativas
    ADD CONSTRAINT fk_alternativas_questoes FOREIGN KEY (questoes_idquestoes) REFERENCES public.questoes(idquestoes) ON DELETE CASCADE;

ALTER TABLE ONLY public.certificados
    ADD CONSTRAINT fk_certificados_usuarios FOREIGN KEY (usuarios_idusuarios) REFERENCES public.usuarios(idusuarios) ON DELETE CASCADE;

ALTER TABLE ONLY public.conteudos
    ADD CONSTRAINT fk_conteudos_temas FOREIGN KEY (temas_idtemas) REFERENCES public.temas(idtemas) ON DELETE CASCADE;

ALTER TABLE ONLY public.questoes
    ADD CONSTRAINT fk_questoes_temas FOREIGN KEY (temas_idtemas) REFERENCES public.temas(idtemas) ON DELETE CASCADE;

ALTER TABLE ONLY public.tentativas_questoes
    ADD CONSTRAINT fk_tentativas_questoes_questao FOREIGN KEY (questoes_idquestoes) REFERENCES public.questoes(idquestoes) ON DELETE CASCADE;

ALTER TABLE ONLY public.tentativas_questoes
    ADD CONSTRAINT fk_tentativas_questoes_tentativa FOREIGN KEY (tentativas_idtentativas) REFERENCES public.tentativas(idtentativas) ON DELETE CASCADE;

ALTER TABLE ONLY public.tentativas
    ADD CONSTRAINT fk_tentativas_usuarios FOREIGN KEY (usuarios_idusuarios) REFERENCES public.usuarios(idusuarios) ON DELETE CASCADE;

ALTER TABLE ONLY public.progresso_estudos
    ADD CONSTRAINT progresso_estudos_temas_idtemas_fkey FOREIGN KEY (temas_idtemas) REFERENCES public.temas(idtemas) ON DELETE CASCADE;

ALTER TABLE ONLY public.progresso_estudos
    ADD CONSTRAINT progresso_estudos_usuarios_idusuarios_fkey FOREIGN KEY (usuarios_idusuarios) REFERENCES public.usuarios(idusuarios) ON DELETE CASCADE;

ALTER TABLE ONLY public.respostas
    ADD CONSTRAINT respostas_alternativas_idalternativas_fkey FOREIGN KEY (alternativas_idalternativas) REFERENCES public.alternativas(idalternativas);

ALTER TABLE ONLY public.respostas
    ADD CONSTRAINT respostas_tentativas_idtentativas_questoes_idquestoes_fkey FOREIGN KEY (tentativas_idtentativas, questoes_idquestoes) REFERENCES public.tentativas_questoes(tentativas_idtentativas, questoes_idquestoes) ON DELETE CASCADE;

ALTER TABLE public.alternativas ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.certificados ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.conteudos ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.limites_autenticacao ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.progresso_estudos ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.questoes ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.respostas ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.sessoes_revogadas ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.temas ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.tentativas ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.tentativas_questoes ENABLE ROW LEVEL SECURITY;

ALTER TABLE public.usuarios ENABLE ROW LEVEL SECURITY;

GRANT USAGE ON SCHEMA public TO service_role;

REVOKE ALL ON FUNCTION public.alterar_senha_segura(p_usuario integer, p_hash_atual text, p_hash_novo text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.alterar_senha_segura(p_usuario integer, p_hash_atual text, p_hash_novo text) TO service_role;

REVOKE ALL ON FUNCTION public.congelar_gabarito_continuidade() FROM PUBLIC;
GRANT ALL ON FUNCTION public.congelar_gabarito_continuidade() TO service_role;

REVOKE ALL ON FUNCTION public.finalizar_prova(p_usuario integer, p_tentativa integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.finalizar_prova(p_usuario integer, p_tentativa integer) TO service_role;

REVOKE ALL ON FUNCTION public.iniciar_prova(p_usuario integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.iniciar_prova(p_usuario integer) TO service_role;

REVOKE ALL ON FUNCTION public.limitar_autenticacao(p_ip text, p_conta text, p_cadastro boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION public.limitar_autenticacao(p_ip text, p_conta text, p_cadastro boolean) TO service_role;

REVOKE ALL ON FUNCTION public.operar_continuidade_prova(p_usuario integer, p_acao text, p_tentativa integer, p_sessao uuid, p_questao integer, p_alternativa integer, p_motivo text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.operar_continuidade_prova(p_usuario integer, p_acao text, p_tentativa integer, p_sessao uuid, p_questao integer, p_alternativa integer, p_motivo text) TO service_role;

REVOKE ALL ON FUNCTION public.operar_continuidade_prova_base(p_usuario integer, p_acao text, p_tentativa integer, p_sessao uuid, p_questao integer, p_alternativa integer, p_motivo text) FROM PUBLIC;
GRANT ALL ON FUNCTION public.operar_continuidade_prova_base(p_usuario integer, p_acao text, p_tentativa integer, p_sessao uuid, p_questao integer, p_alternativa integer, p_motivo text) TO service_role;

REVOKE ALL ON FUNCTION public.proxima_questao_segura(p_usuario integer, p_tentativa integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.proxima_questao_segura(p_usuario integer, p_tentativa integer) TO service_role;

REVOKE ALL ON FUNCTION public.responder_prova(p_usuario integer, p_tentativa integer, p_questao integer, p_alternativa integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.responder_prova(p_usuario integer, p_tentativa integer, p_questao integer, p_alternativa integer) TO service_role;

REVOKE ALL ON FUNCTION public.resumo_continuidade_prova(p_usuario integer, p_tentativa integer) FROM PUBLIC;
GRANT ALL ON FUNCTION public.resumo_continuidade_prova(p_usuario integer, p_tentativa integer) TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.alternativas TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.alternativas_idalternativas_seq TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.certificados TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.certificados_idcertificados_seq TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.conteudos TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.conteudos_idconteudo_seq TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.limites_autenticacao TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.progresso_estudos TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.questoes TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.questoes_idquestoes_seq TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.respostas TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.respostas_idrespostas_seq TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.sessoes_revogadas TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.temas TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.temas_idtemas_seq TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tentativas TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.tentativas_idtentativas_seq TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.tentativas_questoes TO service_role;

GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE public.usuarios TO service_role;

GRANT SELECT,USAGE ON SEQUENCE public.usuarios_idusuarios_seq TO service_role;

COMMIT;
