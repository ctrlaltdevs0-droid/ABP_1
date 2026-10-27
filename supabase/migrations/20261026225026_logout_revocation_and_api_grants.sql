BEGIN;
CREATE TABLE IF NOT EXISTS public.sessoes_revogadas (
  token_hash TEXT PRIMARY KEY CHECK (length(token_hash) = 64),
  expira_em TIMESTAMPTZ NOT NULL,
  revogado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
CREATE INDEX IF NOT EXISTS idx_sessoes_revogadas_expira ON public.sessoes_revogadas(expira_em);
-- JWT próprio da aplicação: Data API disponível exclusivamente para o backend.
DO $rls$
DECLARE tabela TEXT;
BEGIN
  FOREACH tabela IN ARRAY ARRAY['usuarios','temas','conteudos','questoes','alternativas',
    'tentativas','tentativas_questoes','respostas','certificados','progresso_estudos','sessoes_revogadas']
  LOOP
    EXECUTE format('ALTER TABLE public.%I ENABLE ROW LEVEL SECURITY', tabela);
    EXECUTE format('REVOKE ALL ON public.%I FROM PUBLIC, anon, authenticated', tabela);
    EXECUTE format('GRANT SELECT, INSERT, UPDATE, DELETE ON public.%I TO service_role', tabela);
  END LOOP;
END $rls$;
GRANT USAGE ON SCHEMA public TO service_role;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO service_role;
COMMIT;
