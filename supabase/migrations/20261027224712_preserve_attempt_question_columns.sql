-- Preserva o schema original rastreado; alterações posteriores ficam nesta etapa.
BEGIN;
ALTER TABLE public.tentativas_questoes
  ADD COLUMN IF NOT EXISTS resposta_escolhida CHAR(1),
  ADD COLUMN IF NOT EXISTS acertou BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS respondido_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP;
COMMIT;
