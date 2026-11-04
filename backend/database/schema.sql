-- Fonte unica da estrutura, compatibilidade e permissoes do banco ABP_1.
-- Executar no SQL Editor do Supabase do projeto. Suporta banco vazio e o schema legado observado.
-- Reaplicavel; nao remove tabelas/dados nem exige arquivos de migration separados.
-- Os papeis anon, authenticated e service_role sao fornecidos pelo Supabase.
BEGIN;
SELECT pg_advisory_xact_lock(7242026);
SET LOCAL search_path = public, pg_catalog;
-- Backup transacional para desfazer ESTA aplicacao, mesmo depois do COMMIT.
-- Uso posterior no SQL Editor (como postgres):
--   SELECT app_private.abp_restaurar_schema();
-- A restauracao recusa qualquer mudanca posterior nos dados/estrutura public.
-- Nao e backup geral do projeto, Storage ou Auth. Mantenha o backup do Supabase.
CREATE SCHEMA IF NOT EXISTS app_private;
REVOKE ALL ON SCHEMA app_private FROM PUBLIC, anon, authenticated;
CREATE TABLE IF NOT EXISTS app_private.abp_schema_backup (
  id BOOLEAN PRIMARY KEY DEFAULT TRUE CHECK (id),
  criado_em TIMESTAMPTZ NOT NULL DEFAULT clock_timestamp(),
  estado TEXT NOT NULL CHECK (estado IN ('PREPARANDO','APLICADO','RESTAURADO')),
  anterior JSONB NOT NULL,
  anterior_hash TEXT NOT NULL,
  posterior_hash TEXT
);
REVOKE ALL ON app_private.abp_schema_backup FROM PUBLIC, anon, authenticated, service_role;

CREATE OR REPLACE FUNCTION app_private.abp_catalogo()
RETURNS JSONB LANGUAGE sql SECURITY INVOKER SET search_path='' AS $catalog$
SELECT jsonb_build_object(
 'tables',COALESCE((SELECT jsonb_agg(c.relname ORDER BY c.relname)
   FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
   WHERE n.nspname='public' AND c.relkind='r'),'[]'::jsonb),
 'columns',COALESCE((SELECT jsonb_agg(jsonb_build_object('table',c.relname,'name',a.attname,
   'type',format_type(a.atttypid,a.atttypmod),'not_null',a.attnotnull,
   'default',pg_get_expr(d.adbin,d.adrelid)) ORDER BY c.relname,a.attname)
   FROM pg_attribute a JOIN pg_class c ON c.oid=a.attrelid
   JOIN pg_namespace n ON n.oid=c.relnamespace
   LEFT JOIN pg_attrdef d ON d.adrelid=a.attrelid AND d.adnum=a.attnum
   WHERE n.nspname='public' AND c.relkind='r' AND a.attnum>0 AND NOT a.attisdropped),'[]'::jsonb),
 'constraints',COALESCE((SELECT jsonb_agg(jsonb_build_object('table',c.relname,'name',k.conname,
   'definition',pg_get_constraintdef(k.oid)) ORDER BY c.relname,k.conname)
   FROM pg_constraint k JOIN pg_class c ON c.oid=k.conrelid JOIN pg_namespace n ON n.oid=c.relnamespace
   WHERE n.nspname='public'),'[]'::jsonb),
 'indexes',COALESCE((SELECT jsonb_agg(jsonb_build_object('table',i.tablename,'name',i.indexname,
   'definition',i.indexdef) ORDER BY i.indexname) FROM pg_indexes i
   WHERE i.schemaname='public' AND NOT EXISTS(SELECT 1 FROM pg_constraint k
     WHERE k.conindid=to_regclass(format('%I.%I',i.schemaname,i.indexname)))),'[]'::jsonb),
 'rls',COALESCE((SELECT jsonb_agg(jsonb_build_object('table',c.relname,'enabled',c.relrowsecurity,
   'forced',c.relforcerowsecurity) ORDER BY c.relname)
   FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind='r'),'[]'::jsonb),
 'policies',COALESCE((SELECT jsonb_agg(to_jsonb(p) ORDER BY p.tablename,p.policyname)
   FROM pg_policies p WHERE p.schemaname='public'),'[]'::jsonb),
 'triggers',COALESCE((SELECT jsonb_agg(jsonb_build_object('table',c.relname,'name',t.tgname,
   'definition',pg_get_triggerdef(t.oid)) ORDER BY c.relname,t.tgname)
   FROM pg_trigger t JOIN pg_class c ON c.oid=t.tgrelid JOIN pg_namespace n ON n.oid=c.relnamespace
   WHERE n.nspname='public' AND NOT t.tgisinternal),'[]'::jsonb),
 'functions',COALESCE((SELECT jsonb_agg(jsonb_build_object('target',format('%I.%I(%s)',n.nspname,p.proname,
   pg_get_function_identity_arguments(p.oid)),'definition',pg_get_functiondef(p.oid)) ORDER BY p.proname,pg_get_function_identity_arguments(p.oid))
   FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public' AND p.prokind='f'),'[]'::jsonb),
 'permissions',COALESCE((SELECT jsonb_agg(jsonb_build_object('kind',o.kind,'target',o.target,
    'grants',COALESCE((SELECT jsonb_agg(jsonb_build_object('role',CASE WHEN a.grantee=0 THEN 'PUBLIC' ELSE pg_get_userbyid(a.grantee) END,
      'privilege',a.privilege_type,'grantable',a.is_grantable) ORDER BY a.grantee,a.privilege_type)
      FROM aclexplode(o.acl) a WHERE a.grantee=0 OR pg_get_userbyid(a.grantee) IN ('anon','authenticated','service_role')),'[]'::jsonb)) ORDER BY o.kind,o.target)
   FROM (
    SELECT CASE WHEN c.relkind='S' THEN 'SEQUENCE' ELSE 'TABLE' END AS kind,
      format('%I.%I',n.nspname,c.relname) AS target,
      COALESCE(c.relacl,acldefault(CASE WHEN c.relkind='S' THEN 'S'::"char" ELSE 'r'::"char" END,c.relowner)) AS acl
    FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace WHERE n.nspname='public' AND c.relkind IN ('r','S')
    UNION ALL SELECT 'FUNCTION',format('%I.%I(%s)',n.nspname,p.proname,pg_get_function_identity_arguments(p.oid)),
      COALESCE(p.proacl,acldefault('f',p.proowner)) FROM pg_proc p JOIN pg_namespace n ON n.oid=p.pronamespace WHERE n.nspname='public' AND p.prokind='f'
    UNION ALL SELECT 'SCHEMA',quote_ident(n.nspname),COALESCE(n.nspacl,acldefault('n',n.nspowner)) FROM pg_namespace n WHERE n.nspname='public'
   ) o),'[]'::jsonb)
);
$catalog$;

CREATE OR REPLACE FUNCTION app_private.abp_impressao()
RETURNS TEXT LANGUAGE plpgsql SECURITY INVOKER SET search_path='' AS $fingerprint$
DECLARE t RECORD; h TEXT; dados JSONB := '{}'::jsonb;
BEGIN
  FOR t IN SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND c.relkind='r' ORDER BY c.relname
  LOOP
    EXECUTE format('SELECT md5(COALESCE(string_agg(to_jsonb(x)::text,E''\n'' ORDER BY to_jsonb(x)::text),'''')) FROM public.%I x',t.relname) INTO h;
    dados := dados || jsonb_build_object(t.relname,h);
  END LOOP;
  RETURN md5(app_private.abp_catalogo()::text || dados::text);
END;
$fingerprint$;

-- As mesmas tabelas permanecem bloqueadas ate o COMMIT, evitando snapshots parciais.
DO $backup$
DECLARE t RECORD; b app_private.abp_schema_backup;
BEGIN
  FOR t IN SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND c.relkind='r' ORDER BY c.relname
  LOOP EXECUTE format('LOCK TABLE public.%I IN ACCESS EXCLUSIVE MODE',t.relname); END LOOP;
  SELECT * INTO b FROM app_private.abp_schema_backup WHERE id FOR UPDATE;
  IF FOUND AND b.estado='APLICADO' THEN
    IF app_private.abp_impressao() IS DISTINCT FROM b.posterior_hash THEN
      RAISE EXCEPTION 'Banco mudou desde a aplicacao anterior. Nao sobrescrever o ponto de restauracao; fazer backup e revisar a atualizacao.';
    END IF;
  ELSE
    -- O plano de restauracao exige que as escritas de compatibilidade ocorram
    -- somente em tabela/colunas novas; nunca perde valores anteriores.
    IF to_regclass('public.respostas') IS NOT NULL OR EXISTS(
      SELECT 1 FROM information_schema.columns WHERE table_schema='public'
        AND ((table_name='tentativas_questoes' AND column_name='respondida')
          OR (table_name='questoes' AND column_name='status_editorial'))
    ) THEN
      RAISE EXCEPTION 'Este banco ja recebeu parte do schema. Nao e possivel criar retroativamente o rollback do estado original; revisar antes de aplicar.';
    END IF;
    INSERT INTO app_private.abp_schema_backup(id,estado,anterior,anterior_hash)
      VALUES(TRUE,'PREPARANDO',app_private.abp_catalogo(),app_private.abp_impressao())
      ON CONFLICT (id) DO UPDATE SET estado='PREPARANDO',criado_em=clock_timestamp(),
        anterior=EXCLUDED.anterior,anterior_hash=EXCLUDED.anterior_hash,posterior_hash=NULL;
  END IF;
END;
$backup$;

CREATE OR REPLACE FUNCTION app_private.abp_restaurar_schema()
RETURNS TEXT LANGUAGE plpgsql SECURITY INVOKER SET search_path='' AS $restore$
DECLARE b app_private.abp_schema_backup; atual JSONB; x JSONB; antigo JSONB; g JSONB; nomes TEXT; t RECORD;
BEGIN
  PERFORM pg_advisory_xact_lock(7242026);
  FOR t IN SELECT c.relname FROM pg_class c JOIN pg_namespace n ON n.oid=c.relnamespace
    WHERE n.nspname='public' AND c.relkind='r' ORDER BY c.relname
  LOOP EXECUTE format('LOCK TABLE public.%I IN ACCESS EXCLUSIVE MODE',t.relname); END LOOP;
  SELECT * INTO b FROM app_private.abp_schema_backup WHERE id FOR UPDATE;
  IF NOT FOUND OR b.estado<>'APLICADO' THEN RAISE EXCEPTION 'Nao existe aplicacao pendente de restauracao.'; END IF;
  IF app_private.abp_impressao() IS DISTINCT FROM b.posterior_hash THEN
    RAISE EXCEPTION 'Rollback bloqueado: dados ou estrutura mudaram depois da aplicacao. Nenhuma restauracao foi feita.';
  END IF;
  atual := app_private.abp_catalogo();
  FOR x IN SELECT value FROM jsonb_array_elements(atual->'functions') LOOP
    IF NOT EXISTS(SELECT 1 FROM jsonb_array_elements(b.anterior->'functions') a WHERE a->>'target'=x->>'target') THEN
      EXECUTE 'DROP FUNCTION '||(x->>'target');
    END IF;
  END LOOP;
  SELECT string_agg(format('public.%I',v),',') INTO nomes FROM jsonb_array_elements_text(atual->'tables') v
    WHERE NOT (b.anterior->'tables' ? v);
  IF nomes IS NOT NULL THEN EXECUTE 'DROP TABLE '||nomes; END IF;
  -- Remover apenas indices e constraints novos/alterados das tabelas originais.
  FOR x IN SELECT value FROM jsonb_array_elements(atual->'indexes') LOOP
    IF b.anterior->'tables' ? (x->>'table') AND NOT (b.anterior->'indexes' @> jsonb_build_array(x)) THEN
      EXECUTE format('DROP INDEX public.%I',x->>'name');
    END IF;
  END LOOP;
  FOR x IN SELECT value FROM jsonb_array_elements(atual->'constraints') LOOP
    IF b.anterior->'tables' ? (x->>'table') AND NOT (b.anterior->'constraints' @> jsonb_build_array(x)) THEN
      EXECUTE format('ALTER TABLE public.%I DROP CONSTRAINT %I',x->>'table',x->>'name');
    END IF;
  END LOOP;
  FOR x IN SELECT value FROM jsonb_array_elements(atual->'columns') LOOP
    IF NOT (b.anterior->'tables' ? (x->>'table')) THEN CONTINUE; END IF;
    SELECT a INTO antigo FROM jsonb_array_elements(b.anterior->'columns') a WHERE a->>'table'=x->>'table' AND a->>'name'=x->>'name';
    IF antigo IS NULL THEN
      EXECUTE format('ALTER TABLE public.%I DROP COLUMN %I',x->>'table',x->>'name');
    ELSE
      IF antigo->>'type' IS DISTINCT FROM x->>'type' THEN
        EXECUTE format('ALTER TABLE public.%I ALTER COLUMN %I TYPE %s',x->>'table',x->>'name',antigo->>'type');
      END IF;
      IF antigo->>'default' IS DISTINCT FROM x->>'default' THEN
        EXECUTE format('ALTER TABLE public.%I ALTER COLUMN %I %s',x->>'table',x->>'name',
          CASE WHEN antigo->>'default' IS NULL THEN 'DROP DEFAULT' ELSE 'SET DEFAULT '||(antigo->>'default') END);
      END IF;
      IF antigo->>'not_null' IS DISTINCT FROM x->>'not_null' THEN
        EXECUTE format('ALTER TABLE public.%I ALTER COLUMN %I %s NOT NULL',x->>'table',x->>'name',CASE WHEN (antigo->>'not_null')::boolean THEN 'SET' ELSE 'DROP' END);
      END IF;
    END IF;
  END LOOP;
  FOR x IN SELECT value FROM jsonb_array_elements(b.anterior->'constraints') LOOP
    IF NOT (atual->'constraints' @> jsonb_build_array(x)) THEN
      EXECUTE format('ALTER TABLE public.%I ADD CONSTRAINT %I %s',x->>'table',x->>'name',x->>'definition');
    END IF;
  END LOOP;
  FOR x IN SELECT value FROM jsonb_array_elements(b.anterior->'indexes') LOOP
    IF NOT (atual->'indexes' @> jsonb_build_array(x)) THEN EXECUTE x->>'definition'; END IF;
  END LOOP;
  FOR x IN SELECT value FROM jsonb_array_elements(b.anterior->'functions') LOOP
    IF NOT (atual->'functions' @> jsonb_build_array(x)) THEN EXECUTE x->>'definition'; END IF;
  END LOOP;
  FOR x IN SELECT value FROM jsonb_array_elements(b.anterior->'rls') LOOP
    EXECUTE format('ALTER TABLE public.%I %s ROW LEVEL SECURITY',x->>'table',CASE WHEN (x->>'enabled')::boolean THEN 'ENABLE' ELSE 'DISABLE' END);
    EXECUTE format('ALTER TABLE public.%I %s FORCE ROW LEVEL SECURITY',x->>'table',CASE WHEN (x->>'forced')::boolean THEN '' ELSE 'NO' END);
  END LOOP;
  FOR x IN SELECT value FROM jsonb_array_elements(b.anterior->'permissions') LOOP
    EXECUTE format('REVOKE ALL ON %s %s FROM PUBLIC,anon,authenticated,service_role',x->>'kind',x->>'target');
    FOR g IN SELECT value FROM jsonb_array_elements(x->'grants') LOOP
      EXECUTE format('GRANT %s ON %s %s TO %s%s',g->>'privilege',x->>'kind',x->>'target',
        CASE WHEN g->>'role'='PUBLIC' THEN 'PUBLIC' ELSE quote_ident(g->>'role') END,
        CASE WHEN (g->>'grantable')::boolean THEN ' WITH GRANT OPTION' ELSE '' END);
    END LOOP;
  END LOOP;
  IF app_private.abp_impressao() IS DISTINCT FROM b.anterior_hash THEN
    RAISE EXCEPTION 'Restauracao nao corresponde ao estado original; operacao inteira cancelada.';
  END IF;
  UPDATE app_private.abp_schema_backup SET estado='RESTAURADO' WHERE id;
  PERFORM pg_notify('pgrst','reload schema');
  RETURN 'Estrutura, permissoes e dados public restaurados ao ponto anterior. Registro privado preservado.';
END;
$restore$;
REVOKE ALL ON FUNCTION app_private.abp_catalogo(),app_private.abp_impressao(),app_private.abp_restaurar_schema() FROM PUBLIC,anon,authenticated,service_role;

CREATE TABLE IF NOT EXISTS usuarios (
    idusuarios INTEGER GENERATED ALWAYS AS IDENTITY, 
    cpf CHAR(11) NOT NULL,
    nome VARCHAR(50) NOT NULL,
    email TEXT NOT NULL,
    senha_hash VARCHAR(100) NOT NULL,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT pk_usuarios
        PRIMARY KEY (idusuarios),

    CONSTRAINT uq_usuarios_cpf
        UNIQUE (cpf)
);

CREATE TABLE IF NOT EXISTS temas (
    idtemas INTEGER GENERATED ALWAYS AS IDENTITY,
    nome VARCHAR(100) NOT NULL,
    descricao VARCHAR(255),
    ordem INTEGER,
    ativo BOOLEAN DEFAULT TRUE,

    CONSTRAINT pk_temas
        PRIMARY KEY (idtemas),

    CONSTRAINT uq_temas_nome
        UNIQUE (nome)
);

CREATE TABLE IF NOT EXISTS conteudos (
    idconteudo INTEGER GENERATED ALWAYS AS IDENTITY,
    temas_idtemas INTEGER NOT NULL,
    titulo VARCHAR(50),
    descricao VARCHAR(400),
    status BOOLEAN DEFAULT TRUE,
    criado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    recurso_url TEXT,

    CONSTRAINT pk_conteudos
        PRIMARY KEY (idconteudo),

    CONSTRAINT fk_conteudos_temas
        FOREIGN KEY (temas_idtemas)
        REFERENCES temas(idtemas)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS questoes (
    idquestoes INTEGER GENERATED ALWAYS AS IDENTITY,
    temas_idtemas INTEGER NOT NULL,
    enunciado VARCHAR(400) NOT NULL,
    imagem_url VARCHAR(500),
    status BOOLEAN DEFAULT TRUE,

    CONSTRAINT pk_questoes
        PRIMARY KEY (idquestoes),

    CONSTRAINT fk_questoes_temas
        FOREIGN KEY (temas_idtemas)
        REFERENCES temas(idtemas)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS alternativas (
    idalternativas INTEGER GENERATED ALWAYS AS IDENTITY,
    questoes_idquestoes INTEGER NOT NULL,
    letra CHAR(1) NOT NULL,
    texto VARCHAR(200) NOT NULL,
    correta BOOLEAN DEFAULT FALSE,

    CONSTRAINT pk_alternativas
        PRIMARY KEY (idalternativas),

    CONSTRAINT fk_alternativas_questoes
        FOREIGN KEY (questoes_idquestoes)
        REFERENCES questoes(idquestoes)
        ON DELETE CASCADE,

    CONSTRAINT uq_alternativas_letra_questao
        UNIQUE (questoes_idquestoes, letra)
);

CREATE TABLE IF NOT EXISTS tentativas (
    idtentativas INTEGER GENERATED ALWAYS AS IDENTITY,
    usuarios_idusuarios INTEGER NOT NULL,
    iniciado_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    expira_em TIMESTAMP,
    finalizado_em TIMESTAMP,
    status VARCHAR(20) DEFAULT 'EM_ANDAMENTO',
    acertos INTEGER DEFAULT 0,
    percentual DECIMAL(5,2) DEFAULT 0.00,
    aprovado BOOLEAN DEFAULT FALSE,

    CONSTRAINT pk_tentativas
        PRIMARY KEY (idtentativas),

    CONSTRAINT fk_tentativas_usuarios
        FOREIGN KEY (usuarios_idusuarios)
        REFERENCES usuarios(idusuarios)
        ON DELETE CASCADE,

    CONSTRAINT ck_tentativas_acertos
        CHECK (acertos >= 0),

    CONSTRAINT ck_tentativas_percentual
        CHECK (percentual >= 0 AND percentual <= 100)
);


CREATE TABLE IF NOT EXISTS tentativas_questoes (
    tentativas_idtentativas INTEGER NOT NULL,
    questoes_idquestoes INTEGER NOT NULL,

    CONSTRAINT pk_tentativas_questoes
        PRIMARY KEY (
            tentativas_idtentativas,
            questoes_idquestoes
        ),

    CONSTRAINT fk_tentativas_questoes_tentativa
        FOREIGN KEY (tentativas_idtentativas)
        REFERENCES tentativas(idtentativas)
        ON DELETE CASCADE,

    CONSTRAINT fk_tentativas_questoes_questao
        FOREIGN KEY (questoes_idquestoes)
        REFERENCES questoes(idquestoes)
        ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS certificados (
    idcertificados INTEGER GENERATED ALWAYS AS IDENTITY,
    usuarios_idusuarios INTEGER NOT NULL,
    emitido_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    score INTEGER,
    percentual DECIMAL(5,2),
    ativo BOOLEAN DEFAULT TRUE,
    revogado_em TIMESTAMP,

    CONSTRAINT pk_certificados
        PRIMARY KEY (idcertificados),

    CONSTRAINT fk_certificados_usuarios
        FOREIGN KEY (usuarios_idusuarios)
        REFERENCES usuarios(idusuarios)
        ON DELETE CASCADE,

    CONSTRAINT ck_certificados_score
        CHECK (score >= 0),

    CONSTRAINT ck_certificados_percentual
        CHECK (percentual >= 0 AND percentual <= 100)
);

CREATE INDEX IF NOT EXISTS idx_conteudos_temas
    ON conteudos(temas_idtemas);

CREATE INDEX IF NOT EXISTS idx_questoes_temas
    ON questoes(temas_idtemas);

CREATE INDEX IF NOT EXISTS idx_alternativas_questoes
    ON alternativas(questoes_idquestoes);

CREATE INDEX IF NOT EXISTS idx_tentativas_usuarios
    ON tentativas(usuarios_idusuarios);

CREATE INDEX IF NOT EXISTS idx_tentativas_questoes_tentativa
    ON tentativas_questoes(tentativas_idtentativas);

CREATE INDEX IF NOT EXISTS idx_tentativas_questoes_questao
    ON tentativas_questoes(questoes_idquestoes);

CREATE INDEX IF NOT EXISTS idx_certificados_usuarios
    ON certificados(usuarios_idusuarios);



-- Compatibilidade incremental com bancos existentes.
-- Compatibilidade com bancos existentes: não inventa e-mails para usuários antigos.
-- Novos cadastros exigem e-mail na API; registros antigos podem continuar nulos.
ALTER TABLE public.usuarios ADD COLUMN IF NOT EXISTS email TEXT;

-- Remove o default literal incorreto visto no schema remoto; nao altera emails existentes.
ALTER TABLE public.usuarios ALTER COLUMN email DROP DEFAULT;
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
DO $sequence_grant$
DECLARE sequence_name TEXT := pg_get_serial_sequence('public.respostas','idrespostas');
BEGIN
  IF sequence_name IS NOT NULL THEN
    EXECUTE format('GRANT USAGE, SELECT ON SEQUENCE %s TO service_role',sequence_name);
  END IF;
END $sequence_grant$;

ALTER TABLE public.certificados
  ADD COLUMN IF NOT EXISTS codigo_validacao UUID DEFAULT gen_random_uuid(),
  ADD COLUMN IF NOT EXISTS tentativas_idtentativas INTEGER REFERENCES public.tentativas(idtentativas);
CREATE UNIQUE INDEX IF NOT EXISTS certificados_codigo_validacao_uq ON public.certificados(codigo_validacao);
CREATE UNIQUE INDEX IF NOT EXISTS certificados_tentativa_uq ON public.certificados(tentativas_idtentativas);

-- Preserva o schema original rastreado; alterações posteriores ficam nesta etapa.
ALTER TABLE public.tentativas_questoes
  ADD COLUMN IF NOT EXISTS resposta_escolhida CHAR(1),
  ADD COLUMN IF NOT EXISTS acertou BOOLEAN DEFAULT FALSE,
  ADD COLUMN IF NOT EXISTS respondido_em TIMESTAMP DEFAULT CURRENT_TIMESTAMP;


-- Nao inferir resposta pela data: o banco antigo usa CURRENT_TIMESTAMP como default.
-- Recusar respostas antigas sem alternativa correspondente em vez de perder historico.
DO $history$
BEGIN
  IF EXISTS (
    SELECT 1 FROM public.tentativas_questoes tq
    WHERE tq.resposta_escolhida IS NOT NULL AND NOT EXISTS (
      SELECT 1 FROM public.alternativas a
      WHERE a.questoes_idquestoes=tq.questoes_idquestoes AND a.letra=tq.resposta_escolhida
    )
  ) THEN RAISE EXCEPTION 'Resposta legada sem alternativa correspondente; revisar antes da migracao.';
  END IF;
END $history$;
INSERT INTO public.respostas(tentativas_idtentativas,questoes_idquestoes,alternativas_idalternativas,correta,respondida_em)
SELECT tq.tentativas_idtentativas,tq.questoes_idquestoes,a.idalternativas,
       COALESCE(tq.acertou,a.correta,FALSE),tq.respondido_em
FROM public.tentativas_questoes tq
JOIN public.alternativas a ON a.questoes_idquestoes=tq.questoes_idquestoes AND a.letra=tq.resposta_escolhida
WHERE tq.resposta_escolhida IS NOT NULL
ON CONFLICT (tentativas_idtentativas,questoes_idquestoes) DO NOTHING;
UPDATE public.tentativas_questoes tq
SET respondida=TRUE
WHERE NOT tq.respondida AND (tq.resposta_escolhida IS NOT NULL OR EXISTS (
  SELECT 1 FROM public.respostas r
  WHERE r.tentativas_idtentativas=tq.tentativas_idtentativas AND r.questoes_idquestoes=tq.questoes_idquestoes
));

ALTER TABLE conteudos ALTER COLUMN descricao TYPE TEXT;
ALTER TABLE conteudos ALTER COLUMN titulo TYPE TEXT;
ALTER TABLE conteudos ADD COLUMN IF NOT EXISTS codigo_seed TEXT UNIQUE;
ALTER TABLE conteudos ADD COLUMN IF NOT EXISTS recurso_url TEXT;
ALTER TABLE questoes ADD COLUMN IF NOT EXISTS codigo_seed TEXT UNIQUE;
-- Na primeira adaptacao, status=true era a regra de publicacao do projeto.
-- Preserva essa publicacao para questoes validas; novas questoes continuam RASCUNHO.
-- Reaplicacoes nunca sobrescrevem decisoes editoriais posteriores.
DO $editorial$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_attribute
    WHERE attrelid='public.questoes'::regclass AND attname='status_editorial' AND NOT attisdropped) THEN
    ALTER TABLE public.questoes ADD COLUMN status_editorial TEXT NOT NULL DEFAULT 'RASCUNHO'
      CHECK (status_editorial IN ('RASCUNHO', 'REVISAO', 'APROVADO'));
    UPDATE public.questoes q SET status_editorial='APROVADO'
    WHERE q.status IS TRUE AND (
      SELECT count(*)=4 AND count(*) FILTER (WHERE a.correta IS TRUE)=1
        AND count(DISTINCT a.letra)=4 AND bool_and(a.letra IN ('A','B','C','D'))
      FROM public.alternativas a WHERE a.questoes_idquestoes=q.idquestoes
    );
  END IF;
END $editorial$;
CREATE UNIQUE INDEX IF NOT EXISTS uq_alternativa_correta ON alternativas(questoes_idquestoes) WHERE correta;
DO $check$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint WHERE conrelid='public.alternativas'::regclass AND conname='ck_alternativa_letra') THEN
    ALTER TABLE public.alternativas ADD CONSTRAINT ck_alternativa_letra CHECK (letra IN ('A','B','C','D'));
  END IF;
END $check$;

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

CREATE TABLE IF NOT EXISTS public.sessoes_revogadas (
  token_hash TEXT PRIMARY KEY CHECK (length(token_hash) = 64),
  expira_em TIMESTAMPTZ NOT NULL,
  revogado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
ALTER TABLE public.sessoes_revogadas ADD COLUMN IF NOT EXISTS revogado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP;
-- CREATE TABLE IF NOT EXISTS nao acrescenta constraints a tabelas antigas.
DO $token_check$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_constraint
    WHERE conrelid='public.sessoes_revogadas'::regclass AND conname='sessoes_revogadas_token_hash_check') THEN
    ALTER TABLE public.sessoes_revogadas ADD CONSTRAINT sessoes_revogadas_token_hash_check CHECK (length(token_hash)=64);
  END IF;
END $token_check$;
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

ALTER TABLE public.usuarios ADD COLUMN IF NOT EXISTS versao_sessao INTEGER NOT NULL DEFAULT 0;
ALTER TABLE public.tentativas_questoes
  ADD COLUMN IF NOT EXISTS ordem INTEGER CHECK (ordem BETWEEN 1 AND 12),
  ADD COLUMN IF NOT EXISTS iniciado_em TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS expira_em TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS expirou BOOLEAN NOT NULL DEFAULT FALSE;
CREATE UNIQUE INDEX IF NOT EXISTS tentativas_ordem_uq ON public.tentativas_questoes(tentativas_idtentativas, ordem);

-- JWT próprio: somente o backend, usando service_role, pode chamar estas funções.
-- SECURITY INVOKER preserva os privilégios do chamador; nenhum bypass adicional.
CREATE OR REPLACE FUNCTION public.alterar_senha_segura(p_usuario INTEGER, p_hash_atual TEXT, p_hash_novo TEXT)
RETURNS BOOLEAN LANGUAGE plpgsql SECURITY INVOKER SET search_path = '' AS $$
BEGIN
  UPDATE public.usuarios SET senha_hash = p_hash_novo, versao_sessao = versao_sessao + 1
  WHERE idusuarios = p_usuario AND senha_hash = p_hash_atual;
  RETURN FOUND;
END;
$$;

CREATE TABLE IF NOT EXISTS public.limites_autenticacao (
  chave TEXT PRIMARY KEY CHECK (length(chave) = 64),
  inicio TIMESTAMPTZ NOT NULL,
  tentativas INTEGER NOT NULL
);
CREATE INDEX IF NOT EXISTS limites_autenticacao_inicio_idx ON public.limites_autenticacao(inicio);
ALTER TABLE public.limites_autenticacao ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.limites_autenticacao FROM PUBLIC, anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.limites_autenticacao TO service_role;

-- Contadores compartilhados entre instâncias; IP e CPF chegam como HMAC.
DO $install$
BEGIN
  IF to_regprocedure('public.limitar_autenticacao(text,text,boolean)') IS NULL THEN
    EXECUTE $definition$CREATE OR REPLACE FUNCTION public.limitar_autenticacao(p_ip TEXT, p_conta TEXT, p_cadastro BOOLEAN)
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
$$;$definition$;
  END IF;
END $install$;

CREATE OR REPLACE FUNCTION public.iniciar_prova(p_usuario INTEGER)
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

CREATE OR REPLACE FUNCTION public.proxima_questao_segura(p_usuario INTEGER, p_tentativa INTEGER)
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

CREATE OR REPLACE FUNCTION public.responder_prova(p_usuario INTEGER,p_tentativa INTEGER,p_questao INTEGER,p_alternativa INTEGER)
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

CREATE OR REPLACE FUNCTION public.finalizar_prova(p_usuario INTEGER,p_tentativa INTEGER)
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
-- A funcao do event trigger do Supabase nao e uma RPC da aplicacao.
DO $secure_event_trigger$
BEGIN
  IF to_regprocedure('public.rls_auto_enable()') IS NOT NULL THEN
    EXECUTE 'REVOKE ALL ON FUNCTION public.rls_auto_enable() FROM PUBLIC, anon, authenticated';
    EXECUTE 'GRANT EXECUTE ON FUNCTION public.rls_auto_enable() TO service_role';
  END IF;
END $secure_event_trigger$;
NOTIFY pgrst, 'reload schema';



-- Campos e tabela usados pelo projeto remoto e pelas rotas de estudos.
ALTER TABLE public.tentativas ADD COLUMN IF NOT EXISTS sessao_prova UUID;
CREATE TABLE IF NOT EXISTS public.respostas_estudos (
  idrespostas_estudos BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  usuarios_idusuarios INTEGER NOT NULL REFERENCES public.usuarios(idusuarios) ON DELETE CASCADE,
  questoes_idquestoes INTEGER NOT NULL REFERENCES public.questoes(idquestoes) ON DELETE CASCADE,
  alternativa_escolhida CHAR(1) NOT NULL,
  acertou BOOLEAN NOT NULL,
  respondido_em TIMESTAMPTZ NOT NULL DEFAULT now()
);
-- Alinha tambem bancos que receberam uma versao anterior deste schema.
-- Datas nulas, se houver, devem ser revisadas: nao fabricar historico.
ALTER TABLE public.respostas_estudos ALTER COLUMN respondido_em SET NOT NULL;
DO $study_fks$
DECLARE f RECORD;
BEGIN
  FOR f IN SELECT conname,pg_get_constraintdef(oid) AS definition
    FROM pg_constraint WHERE conrelid='public.respostas_estudos'::regclass
      AND contype='f' AND confdeltype<>'c'
      AND conname IN ('respostas_estudos_usuarios_idusuarios_fkey','respostas_estudos_questoes_idquestoes_fkey')
  LOOP
    EXECUTE format('ALTER TABLE public.respostas_estudos DROP CONSTRAINT %I',f.conname);
    EXECUTE format('ALTER TABLE public.respostas_estudos ADD CONSTRAINT %I %s ON DELETE CASCADE',
      f.conname,regexp_replace(f.definition,' ON DELETE (NO ACTION|RESTRICT|SET NULL|SET DEFAULT)',''));
  END LOOP;
END $study_fks$;
CREATE INDEX IF NOT EXISTS idx_respostas_estudos_usuario ON public.respostas_estudos(usuarios_idusuarios);
CREATE INDEX IF NOT EXISTS idx_respostas_estudos_questao ON public.respostas_estudos(questoes_idquestoes);
-- Indices de apoio para as FKs usadas em exclusoes e consultas relacionadas.
CREATE INDEX IF NOT EXISTS idx_progresso_estudos_tema ON public.progresso_estudos(temas_idtemas);
CREATE INDEX IF NOT EXISTS idx_respostas_alternativa ON public.respostas(alternativas_idalternativas);
ALTER TABLE public.respostas_estudos ENABLE ROW LEVEL SECURITY;
REVOKE ALL ON public.respostas_estudos FROM PUBLIC, anon, authenticated;
GRANT SELECT, INSERT, UPDATE, DELETE ON public.respostas_estudos TO service_role;
DO $sequence_grant$
DECLARE sequence_name TEXT := pg_get_serial_sequence('public.respostas_estudos','idrespostas_estudos');
BEGIN
  IF sequence_name IS NOT NULL THEN
    EXECUTE format('GRANT USAGE, SELECT ON SEQUENCE %s TO service_role',sequence_name);
  END IF;
END $sequence_grant$;

NOTIFY pgrst, 'reload schema';
-- Somente apos a aplicacao completa, registrar o estado que pode ser desfeito.
UPDATE app_private.abp_schema_backup
SET posterior_hash=app_private.abp_impressao(),estado='APLICADO' WHERE id;
COMMIT;

-- RESTAURACAO APOS O COMMIT: executar SOMENTE a chamada abaixo, separadamente.
-- SELECT app_private.abp_restaurar_schema();
-- A funcao roda atomicamente e bloqueia a restauracao se o banco tiver mudado.
-- Nao execute novamente este arquivo inteiro para pedir rollback.
