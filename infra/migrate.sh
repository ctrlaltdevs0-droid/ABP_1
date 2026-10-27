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
SELECT NOT EXISTS (SELECT 1 FROM app_private.schema_migrations WHERE nome='$name' AND checksum<>'$checksum') AS valido \gset
\if :valido
\else
DO \$checksum\$
BEGIN
  RAISE EXCEPTION 'Arquivo aplicado foi modificado. Criar nova migração.';
END \$checksum\$;
\endif
\if :aplicar
SQL
    # Os scripts existentes já têm delimitadores de transação. A transação externa inclui o registro.
    sed -e '/^BEGIN;$/d' -e '/^COMMIT;$/d' "$file"
    printf '\nINSERT INTO app_private.schema_migrations(nome,checksum) VALUES (\047%s\047,\047%s\047);\n' "$name" "$checksum"
    printf '\\endif\nCOMMIT;\n'
  } > "$job"
  psql -X -v ON_ERROR_STOP=1 -f "$job"
  rm -f "$job"
}
# Volume novo: schema antes das migrações. Não adotar automaticamente um banco legado.
apply '000_schema.sql' /base/schema.sql
for file in /migrations/*.sql; do apply "$(basename "$file")" "$file"; done
apply 'seed_temas_v1.sql' /base/seed.sql
apply 'seed_estudos_v1.sql' /base/seed-estudos.sql
psql -X -v ON_ERROR_STOP=1 -f /base/validar-estudos.sql
