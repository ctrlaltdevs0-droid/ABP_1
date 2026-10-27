BEGIN;
ALTER TABLE conteudos ALTER COLUMN descricao TYPE TEXT;
ALTER TABLE conteudos ALTER COLUMN titulo TYPE TEXT;
ALTER TABLE conteudos ADD COLUMN IF NOT EXISTS codigo_seed TEXT UNIQUE;
ALTER TABLE conteudos ADD COLUMN IF NOT EXISTS recurso_url TEXT;
ALTER TABLE questoes ADD COLUMN IF NOT EXISTS codigo_seed TEXT UNIQUE;
ALTER TABLE questoes ADD COLUMN IF NOT EXISTS status_editorial TEXT NOT NULL DEFAULT 'RASCUNHO'
  CHECK (status_editorial IN ('RASCUNHO', 'REVISAO', 'APROVADO'));
CREATE UNIQUE INDEX IF NOT EXISTS uq_alternativa_correta ON alternativas(questoes_idquestoes) WHERE correta;
ALTER TABLE alternativas ADD CONSTRAINT ck_alternativa_letra CHECK (letra IN ('A','B','C','D'));

CREATE TABLE IF NOT EXISTS progresso_estudos (
  usuarios_idusuarios INTEGER NOT NULL REFERENCES usuarios(idusuarios) ON DELETE CASCADE,
  temas_idtemas INTEGER NOT NULL REFERENCES temas(idtemas) ON DELETE CASCADE,
  concluido_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (usuarios_idusuarios, temas_idtemas)
);
ALTER TABLE progresso_estudos ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON progresso_estudos FROM PUBLIC, anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON progresso_estudos TO service_role;
-- A autenticação usa JWT próprio. Somente o backend acessa esta tabela.
COMMIT;
