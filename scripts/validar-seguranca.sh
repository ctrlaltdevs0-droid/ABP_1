#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."
# Banco efêmero sem portas, rede ou volumes persistentes; não usa .env do projeto.
container="abp_security_test_$(date +%s)_$$"
trap 'docker rm -f "$container" >/dev/null 2>&1 || true' EXIT
docker run --detach --name "$container" --network none --tmpfs /var/lib/postgresql/data \
  -e POSTGRES_HOST_AUTH_METHOD=trust postgres:17.11-bookworm >/dev/null
for attempt in {1..30}; do
  if docker exec "$container" pg_isready -U postgres >/dev/null 2>&1; then break; fi
  sleep 1
done
run_sql() { docker exec -i "$container" psql -X -U postgres -v ON_ERROR_STOP=1; }
run_sql <<'SQL' >/dev/null
CREATE ROLE anon NOLOGIN;
CREATE ROLE authenticated NOLOGIN;
CREATE ROLE service_role NOLOGIN BYPASSRLS;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
SQL
run_sql < backend/database/schema.sql >/dev/null
for migration in supabase/migrations/*.sql; do run_sql < "$migration" >/dev/null; done
run_sql < backend/database/seed.sql >/dev/null
SECURITY_TEST_CONTAINER="$container" node --test backend/test/provas-db.test.js
