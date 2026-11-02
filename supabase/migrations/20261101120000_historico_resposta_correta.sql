-- Guarda a letra correta no histórico da prova, mesmo se a questão mudar depois.
BEGIN;
ALTER TABLE public.tentativas_questoes
  ADD COLUMN IF NOT EXISTS resposta_correta CHAR(1);
COMMIT;
