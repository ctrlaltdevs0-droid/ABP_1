#!/bin/sh
set -eu
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" --set=auth_password="$DB_AUTH_PASSWORD" <<'SQL'
CREATE ROLE anon NOLOGIN;
CREATE ROLE authenticated NOLOGIN;
CREATE ROLE service_role NOLOGIN BYPASSRLS;
CREATE ROLE authenticator LOGIN NOINHERIT NOCREATEDB NOCREATEROLE NOSUPERUSER;
SELECT format('ALTER ROLE authenticator PASSWORD %L', :'auth_password') \gexec
GRANT anon, authenticated, service_role TO authenticator;
REVOKE CREATE ON SCHEMA public FROM PUBLIC;
SQL
