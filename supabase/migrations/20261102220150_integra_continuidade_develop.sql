BEGIN;
-- Uma questão ainda não respondida não pode nascer com data de resposta.
ALTER TABLE public.tentativas_questoes ALTER COLUMN respondido_em DROP DEFAULT;

-- Adota apenas tentativas legadas completas (12 temas distintos). Não sorteia
-- novamente nem transforma uma tentativa incompleta em uma prova válida.
WITH elegiveis AS (
  SELECT tq.tentativas_idtentativas
  FROM public.tentativas_questoes tq JOIN public.questoes q ON q.idquestoes=tq.questoes_idquestoes
  GROUP BY tq.tentativas_idtentativas
  HAVING count(*)=12 AND count(DISTINCT q.temas_idtemas)=12 AND count(tq.ordem)=0
), ordenadas AS (
  SELECT tq.tentativas_idtentativas,tq.questoes_idquestoes,
    row_number() OVER(PARTITION BY tq.tentativas_idtentativas ORDER BY t.ordem NULLS LAST,t.idtemas)::INTEGER AS ordem
  FROM public.tentativas_questoes tq JOIN elegiveis e USING(tentativas_idtentativas)
  JOIN public.questoes q ON q.idquestoes=tq.questoes_idquestoes
  JOIN public.temas t ON t.idtemas=q.temas_idtemas
)
UPDATE public.tentativas_questoes tq SET ordem=o.ordem,
  respondida=(tq.respondida OR tq.expirou OR (tq.respondido_em IS NOT NULL AND tq.resposta_escolhida IS NOT NULL))
FROM ordenadas o WHERE tq.tentativas_idtentativas=o.tentativas_idtentativas AND tq.questoes_idquestoes=o.questoes_idquestoes;

-- Preserva a regra adicionada pela develop: concluir os 12 temas antes de
-- iniciar uma nova prova, também no cliente que usa sessão por documento.
ALTER FUNCTION public.operar_continuidade_prova(INTEGER,TEXT,INTEGER,UUID,INTEGER,INTEGER,TEXT)
  RENAME TO operar_continuidade_prova_base;
CREATE FUNCTION public.operar_continuidade_prova(
  p_usuario INTEGER,p_acao TEXT,p_tentativa INTEGER DEFAULT NULL,p_sessao UUID DEFAULT NULL,
  p_questao INTEGER DEFAULT NULL,p_alternativa INTEGER DEFAULT NULL,p_motivo TEXT DEFAULT NULL)
RETURNS JSONB LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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

-- O histórico da develop lê resposta_correta. Congela o gabarito no primeiro
-- encerramento, inclusive timeout/interrupção, sem expô-lo durante a prova.
CREATE FUNCTION public.congelar_gabarito_continuidade()
RETURNS trigger LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
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
CREATE TRIGGER congelar_gabarito_continuidade BEFORE UPDATE ON public.tentativas_questoes
  FOR EACH ROW EXECUTE FUNCTION public.congelar_gabarito_continuidade();

REVOKE ALL ON FUNCTION public.operar_continuidade_prova(INTEGER,TEXT,INTEGER,UUID,INTEGER,INTEGER,TEXT),
  public.congelar_gabarito_continuidade() FROM PUBLIC,anon,authenticated;
GRANT EXECUTE ON FUNCTION public.operar_continuidade_prova(INTEGER,TEXT,INTEGER,UUID,INTEGER,INTEGER,TEXT),
  public.congelar_gabarito_continuidade() TO service_role;
NOTIFY pgrst, 'reload schema';
COMMIT;
