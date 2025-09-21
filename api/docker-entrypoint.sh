#!/usr/bin/env sh
set -eu

# Map Railway's $PORT -> PostgREST's port if not already set
if [ -n "${PORT:-}" ] && [ -z "${PGRST_SERVER_PORT:-}" ]; then
  export PGRST_SERVER_PORT="$PORT"
fi

# Build a DB URI if not supplied directly
# Expected vars (if you don't set PGRST_DB_URI): POSTGRES_HOST, POSTGRES_DB, POSTGRES_USER, POSTGRES_PASSWORD
if [ -z "${PGRST_DB_URI:-}" ] && [ -n "${POSTGRES_HOST:-}" ]; then
  PGPORT="${POSTGRES_PORT:-5432}"
  SSLMODE="${POSTGRES_SSLMODE:-prefer}"   # set to 'disable' or 'require' as needed
  export PGRST_DB_URI="postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:${PGPORT}/${POSTGRES_DB}?sslmode=${SSLMODE}"
fi


: "${PGRST_SERVER_PORT:=3000}"
: "${PGRST_LOG_LEVEL:=info}"

exec postgrest