BEGIN;

ALTER TABLE public.tentativas ADD COLUMN sessao_prova UUID;
ALTER TABLE public.tentativas ADD COLUMN ultimo_contato_em TIMESTAMPTZ;
ALTER TABLE public.tentativas_questoes ADD COLUMN motivo_encerramento TEXT
  CHECK (motivo_encerramento IN ('RESPOSTA','TEMPO','CONEXAO','FECHAMENTO','RETOMADA'));

-- A consulta nunca entrega gabaritos ou dados de outro candidato.
CREATE FUNCTION public.resumo_continuidade_prova(p_usuario INTEGER, p_tentativa INTEGER)
RETURNS JSONB LANGUAGE sql SECURITY INVOKER SET search_path = '' AS $$
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

-- Uma transação e o mesmo bloqueio da tentativa para todas as ações.
-- Sessão por documento impede que pagehide/requests atrasados de uma aba
-- fechem a questão que outra aba já começou.
CREATE FUNCTION public.operar_continuidade_prova(
  p_usuario INTEGER, p_acao TEXT, p_tentativa INTEGER DEFAULT NULL,
  p_sessao UUID DEFAULT NULL, p_questao INTEGER DEFAULT NULL,
  p_alternativa INTEGER DEFAULT NULL, p_motivo TEXT DEFAULT NULL)
RETURNS JSONB LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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

REVOKE ALL ON FUNCTION public.resumo_continuidade_prova(INTEGER,INTEGER),
  public.operar_continuidade_prova(INTEGER,TEXT,INTEGER,UUID,INTEGER,INTEGER,TEXT) FROM PUBLIC,anon,authenticated;
GRANT EXECUTE ON FUNCTION public.resumo_continuidade_prova(INTEGER,INTEGER),
  public.operar_continuidade_prova(INTEGER,TEXT,INTEGER,UUID,INTEGER,INTEGER,TEXT) TO service_role;
NOTIFY pgrst, 'reload schema';
COMMIT;
