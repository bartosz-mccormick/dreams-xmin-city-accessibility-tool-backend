# Use the official PostgREST image
FROM postgrest/postgrest:v13.0.7

ENV PGRST_SERVER_HOST=*
ENV PGRST_DB_SCHEMAS=api
ENV PGRST_DB_ANON_ROLE=anon

# Copy wrapper and mark it executable in one step (no RUN needed)
COPY --chmod=755 docker-entrypoint.sh /usr/bin/docker-entrypoint.sh

EXPOSE 3000
ENTRYPOINT ["/usr/bin/docker-entrypoint.sh"]
