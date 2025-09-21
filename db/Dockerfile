# Debian-based PostGIS image
FROM postgis/postgis:16-3.5

# keep PG major configurable 
ARG PG_MAJOR=16

# Install H3 extension from PGDG 
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends "postgresql-${PG_MAJOR}-h3"; \
    rm -rf /var/lib/apt/lists/*

# Create extensions on first init
RUN printf "CREATE EXTENSION IF NOT EXISTS postgis;\nCREATE EXTENSION IF NOT EXISTS h3;\n" \
    > /docker-entrypoint-initdb.d/01-extensions.sql

EXPOSE 5432
