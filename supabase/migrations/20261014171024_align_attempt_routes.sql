ALTER TABLE public.tentativas_questoes
  ADD COLUMN IF NOT EXISTS respondida BOOLEAN NOT NULL DEFAULT FALSE;

CREATE TABLE IF NOT EXISTS public.respostas (
  idrespostas INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  tentativas_idtentativas INTEGER NOT NULL,
  questoes_idquestoes INTEGER NOT NULL,
  alternativas_idalternativas INTEGER NOT NULL REFERENCES public.alternativas(idalternativas),
  correta BOOLEAN NOT NULL,
  respondida_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  UNIQUE (tentativas_idtentativas, questoes_idquestoes),
  FOREIGN KEY (tentativas_idtentativas, questoes_idquestoes)
    REFERENCES public.tentativas_questoes(tentativas_idtentativas, questoes_idquestoes)
    ON DELETE CASCADE
);
ALTER TABLE public.respostas ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.respostas FROM anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.respostas TO service_role;
GRANT USAGE, SELECT ON SEQUENCE public.respostas_idrespostas_seq TO service_role;

ALTER TABLE public.certificados
  ADD COLUMN IF NOT EXISTS codigo_validacao UUID DEFAULT gen_random_uuid(),
  ADD COLUMN IF NOT EXISTS tentativas_idtentativas INTEGER REFERENCES public.tentativas(idtentativas);
CREATE UNIQUE INDEX IF NOT EXISTS certificados_codigo_validacao_uq ON public.certificados(codigo_validacao);
CREATE UNIQUE INDEX IF NOT EXISTS certificados_tentativa_uq ON public.certificados(tentativas_idtentativas);
