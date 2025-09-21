# Debian-based PostGIS image
FROM postgis/postgis:16-3.5

# keep PG major configurable 
ARG PG_MAJOR=16

# Install H3 extension from PGDG 
RUN set -eux; \
    apt-get update; \
    apt-get install -y --no-install-recommends "postgresql-${PG_MAJOR}-h3"; \
    rm -rf /var/lib/apt/lists/*

# Init scripts (run only on first init of the data dir)
COPY initdb/01-extensions.sql /docker-entrypoint-initdb.d/01-extensions.sql
COPY initdb/02-bootstrap.sh     /docker-entrypoint-initdb.d/02-bootstrap.sh
RUN chmod +x /docker-entrypoint-initdb.d/02-bootstrap.sh

EXPOSE 5432
