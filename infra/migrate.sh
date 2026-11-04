#!/bin/sh
set -eu
# Uma execução exclusiva, checksum por arquivo e transação por etapa.
apply() {
  name="$1"
  file="$2"
  checksum=$(sha256sum "$file" | cut -d ' ' -f 1)
  job=$(mktemp)
  {
    cat <<SQL
BEGIN;
SELECT pg_advisory_xact_lock(7242026);
CREATE SCHEMA IF NOT EXISTS app_private;
CREATE TABLE IF NOT EXISTS app_private.schema_migrations (
  nome TEXT PRIMARY KEY, checksum TEXT NOT NULL, aplicado_em TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);
SELECT NOT EXISTS (SELECT 1 FROM app_private.schema_migrations WHERE nome='$name') AS aplicar \gset
SELECT NOT EXISTS (SELECT 1 FROM app_private.schema_migrations WHERE nome='$name' AND checksum<>'$checksum' AND NOT (nome='000_schema.sql' AND checksum IN ('6e74afa4d81995a1024bdba2b533900926c2dfc817f525e2d607c08f168a49db', '1d32b5a935da4959035346bec559a11c16080fdf3b5904e2a1cd44cd85ad356e'))) AS valido \gset
\if :valido
\else
DO \$checksum\$
BEGIN
  RAISE EXCEPTION 'Arquivo aplicado foi modificado: % (checksum atual: %). Criar nova migração.', '$name', '$checksum';
END \$checksum\$;
\endif
\if :aplicar
SQL
    # Os scripts existentes já têm delimitadores de transação. A transação externa inclui o registro.
    if [ "${3:-}" != baseline ]; then
      sed -e '/^[[:space:]]*BEGIN;[[:space:]]*$/d' -e '/^[[:space:]]*COMMIT;[[:space:]]*$/d' "$file"
    fi
    printf '\nINSERT INTO app_private.schema_migrations(nome,checksum) VALUES (\047%s\047,\047%s\047);\n' "$name" "$checksum"
    printf '\\endif\nCOMMIT;\n'
  } > "$job"
  psql -X -v ON_ERROR_STOP=1 -f "$job"
  rm -f "$job"
}
# Banco novo usa a estrutura consolidada. O checksum original continua aceito
# apenas para atualizar volumes que já registraram os schemas anteriores
# dos commits 18fac72a e a03440d8 (este último sem conteudos.recurso_url).
apply '000_schema.sql' /base/schema.sql
# O registro do schema identifica a baseline inclusive após execução interrompida.
consolidado=$(psql -X -At -v ON_ERROR_STOP=1 -c "SELECT checksum = '$(sha256sum /base/schema.sql | cut -d ' ' -f 1)' FROM app_private.schema_migrations WHERE nome='000_schema.sql'")
for file in /migrations/*.sql; do
  [ -f "$file" ] || continue
  mode=''
  if [ "$consolidado" = t ] && [ "$(basename "$file")" \< '20261102220151' ]; then
    mode=baseline
  fi
  apply "$(basename "$file")" "$file" "$mode"
done
# A carga consolidada é idempotente também em volumes com as duas cargas antigas.
apply 'seed_completo_v3.sql' /base/seed.sql
