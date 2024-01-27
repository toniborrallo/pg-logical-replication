# Dockerfile for pg-replica
FROM postgres:14.7

# Copy configuration files
COPY postgresql.conf /etc/postgresql/postgresql.conf
COPY pg_hba.conf /etc/postgresql/pg_hba.conf

RUN chown postgres:postgres /etc/postgresql/postgresql.conf /etc/postgresql/pg_hba.conf

# Copy DDL script
COPY schema.sql /docker-entrypoint-initdb.d/

# Expose the PostgreSQL port
EXPOSE 25432

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]