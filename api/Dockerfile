# Use the official PostgREST image
FROM postgrest/postgrest:v13.0.7

ENV PGRST_SERVER_HOST=*
ENV PGRST_DB_SCHEMAS=api
ENV PGRST_DB_ANON_ROLE=anon

# Small wrapper that:
# - sets PGRST_SERVER_PORT from $PORT (Railway) if not provided
# - builds PGRST_DB_URI from POSTGRES_* if not provided
COPY --chmod=755 docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]


