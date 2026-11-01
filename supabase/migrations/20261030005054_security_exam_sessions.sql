BEGIN;

ALTER TABLE public.usuarios ADD COLUMN versao_sessao INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.tentativas_questoes
  ADD COLUMN ordem INTEGER CHECK (ordem BETWEEN 1 AND 12),
  ADD COLUMN iniciado_em TIMESTAMPTZ,
  ADD COLUMN expira_em TIMESTAMPTZ,
  ADD COLUMN expirou BOOLEAN NOT NULL DEFAULT FALSE;
CREATE UNIQUE INDEX tentativas_ordem_uq ON public.tentativas_questoes(tentativas_idtentativas, ordem);

-- JWT próprio: somente o backend, usando service_role, pode chamar estas funções.
-- SECURITY INVOKER preserva os privilégios do chamador; nenhum bypass adicional.
CREATE FUNCTION public.alterar_senha_segura(p_usuario INTEGER, p_hash_atual TEXT, p_hash_novo TEXT)
RETURNS BOOLEAN LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
BEGIN
  UPDATE public.usuarios SET senha_hash = p_hash_novo, versao_sessao = versao_sessao + 1
  WHERE idusuarios = p_usuario AND senha_hash = p_hash_atual;
  RETURN FOUND;
END;
$$;

CREATE TABLE public.limites_autenticacao (
  chave TEXT PRIMARY KEY CHECK (length(chave) = 64),
  inicio TIMESTAMPTZ NOT NULL,
  tentativas INTEGER NOT NULL
);
CREATE INDEX limites_autenticacao_inicio_idx ON public.limites_autenticacao(inicio);
ALTER TABLE public.limites_autenticacao ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.limites_autenticacao FROM PUBLIC, anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.limites_autenticacao TO service_role;

-- Contadores compartilhados entre instâncias; IP e CPF chegam como HMAC.
CREATE FUNCTION public.limitar_autenticacao(p_ip TEXT, p_conta TEXT, p_cadastro BOOLEAN)
RETURNS JSONB LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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

CREATE FUNCTION public.iniciar_prova(p_usuario INTEGER)
RETURNS JSONB LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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

CREATE FUNCTION public.proxima_questao_segura(p_usuario INTEGER, p_tentativa INTEGER)
RETURNS JSONB LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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

CREATE FUNCTION public.responder_prova(p_usuario INTEGER,p_tentativa INTEGER,p_questao INTEGER,p_alternativa INTEGER)
RETURNS JSONB LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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

CREATE FUNCTION public.finalizar_prova(p_usuario INTEGER,p_tentativa INTEGER)
RETURNS JSONB LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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

REVOKE ALL ON FUNCTION public.alterar_senha_segura(INTEGER,TEXT,TEXT),
  public.limitar_autenticacao(TEXT,TEXT,BOOLEAN),public.iniciar_prova(INTEGER),
  public.proxima_questao_segura(INTEGER,INTEGER),public.responder_prova(INTEGER,INTEGER,INTEGER,INTEGER),
  public.finalizar_prova(INTEGER,INTEGER) FROM PUBLIC,anon,authenticated;
GRANT EXECUTE ON FUNCTION public.alterar_senha_segura(INTEGER,TEXT,TEXT),
  public.limitar_autenticacao(TEXT,TEXT,BOOLEAN),public.iniciar_prova(INTEGER),
  public.proxima_questao_segura(INTEGER,INTEGER),public.responder_prova(INTEGER,INTEGER,INTEGER,INTEGER),
  public.finalizar_prova(INTEGER,INTEGER) TO service_role;
NOTIFY pgrst, 'reload schema';
COMMIT;
