#!/bin/sh
set -eu
# Apenas executa as duas fontes de banco; cada arquivo controla sua transacao.
# Reaplicacao suportada pelo SQL, sem historico/checksum de migrations separados.
psql -X -v ON_ERROR_STOP=1 -f /base/schema.sql
psql -X -v ON_ERROR_STOP=1 -f /base/seed.sql
