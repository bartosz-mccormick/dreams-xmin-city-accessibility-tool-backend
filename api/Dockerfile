# Use the official PostgREST image
FROM postgrest/postgrest:v13.0.7

# Listen on all interfaces by default
ENV PGRST_SERVER_HOST=!4
ENV PGRST_DB_SCHEMAS=api
ENV PGRST_DB_ANON_ROLE=anon

# Small wrapper that:
# - sets PGRST_SERVER_PORT from $PORT (Railway) if not provided
# - builds PGRST_DB_URI from POSTGRES_* if not provided
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
