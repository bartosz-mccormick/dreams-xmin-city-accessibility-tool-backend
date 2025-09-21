#!/usr/bin/env bash
set -euo pipefail

: "${POSTGRES_USER:?Need POSTGRES_USER}"
: "${POSTGRES_DB:?Need POSTGRES_DB}"
: "${AUTHENTICATOR_POSTGRES_PASSWORD:?Need AUTHENTICATOR_POSTGRES_PASSWORD}"

psql -v ON_ERROR_STOP=1 \
  --username "$POSTGRES_USER" \
  --dbname "$POSTGRES_DB" \
  --set=auth_pw="$AUTHENTICATOR_POSTGRES_PASSWORD" <<'SQL'
-- Roles (idempotent)
DO $$
BEGIN
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'anon') THEN
    CREATE ROLE anon NOLOGIN;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'app_owner') THEN
    CREATE ROLE app_owner NOLOGIN;
  END IF;
  IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'authenticator') THEN
    CREATE ROLE authenticator NOINHERIT LOGIN;
  END IF;
END
$$;

-- Password for authenticator
ALTER ROLE authenticator WITH PASSWORD :'auth_pw';

-- Allow authenticator to SET ROLE anon
GRANT anon TO authenticator;

-- Minimal API schemas, seed, and grants
CREATE SCHEMA IF NOT EXISTS api;
CREATE SCHEMA IF NOT EXISTS api_data;

CREATE TABLE IF NOT EXISTS api.hello_world (
  id  SERIAL PRIMARY KEY,
  msg text
);

INSERT INTO api.hello_world (msg)
SELECT 'hi from postgrest!'
WHERE NOT EXISTS (SELECT 1 FROM api.hello_world);

-- anon: only schema usage (no table access)
GRANT USAGE ON SCHEMA api TO anon;

-- app_owner: usage + read on api_data
GRANT USAGE ON SCHEMA api TO app_owner;
GRANT USAGE ON SCHEMA api_data TO app_owner;
GRANT SELECT ON ALL TABLES IN SCHEMA api_data TO app_owner;
ALTER DEFAULT PRIVILEGES IN SCHEMA api_data
  GRANT SELECT ON TABLES TO app_owner;
SQL
