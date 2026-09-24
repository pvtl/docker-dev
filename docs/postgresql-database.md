# PostgreSQL

We use the [`pgvector/pgvector`](https://github.com/pgvector/pgvector) Docker image.


## Installation

PostgreSQL is an **optional** service and is **not enabled by default**. To enable it, append `opt/postgresql.yml` to the `COMPOSE_FILE` list in `.env`.

If you already have optional services enabled, append the PostgreSQL file to your existing list. Then start the service with `docker compose up -d` (or run `docker compose up -d --remove-orphans` to apply the updated service list if you've also made other changes).


## Connecting

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `postgres` (from a container)<br>`localhost` (from your computer) |
| Port | `5432` |
| Username | `root` |
| Database | `root` |
| Password | `dbroot` by default; set `POSTGRES_PASSWORD` to override |

If you're looking for a suitable desktop app, we recommend [TablePlus](https://tableplus.com/).


## PostgreSQL extensions

The PostgreSQL image includes `pgvector` and `pg_trgm`. Both are enabled by default in the `root` database and in new databases created with PostgreSQL's default template. During first-time initialization, the extensions are installed in `template1` before the `root` database is created, so both inherit them automatically. This makes the `vector` type and `gin_trgm_ops` available.

While these are enabled by default, if needed, you can enable them manually:

```bash
docker compose exec postgres psql -U root -d DB_NAME -c 'CREATE EXTENSION IF NOT EXISTS vector;'
docker compose exec postgres psql -U root -d DB_NAME -c 'CREATE EXTENSION IF NOT EXISTS pg_trgm;'
```

To update the extensions after pulling a newer image, recreate the container and update each extension in the databases that use it:

```bash
docker compose pull postgres
docker compose up -d postgres
docker compose exec postgres psql -U root -d DB_NAME -c 'ALTER EXTENSION vector UPDATE;'
docker compose exec postgres psql -U root -d DB_NAME -c 'ALTER EXTENSION pg_trgm UPDATE;'
```


## Where is my data stored?

See `data/postgres/`.

All database data is stored on your host machine (not inside the Docker container). The PostgreSQL 18 image stores its cluster in a version-specific subdirectory under `/var/lib/postgresql`, which is mounted to `data/postgres/` on the host. This makes it simple to update your Docker Dev environment without losing any data.

> Warning: It is very easy to break your database if you touch any files in there. We recommend keeping SQL dumps of anything important.


## Export SQL dumps of databases or tables

You can use `pg_dump` from inside the container to export a database:

```bash
# Run from the root folder of "docker-dev"
docker compose exec -T postgres pg_dump -U root DB_NAME > DB_NAME.dump.sql
```

To export specific tables, add one or more `-t` options:

```bash
docker compose exec -T postgres pg_dump -U root -d DB_NAME -t TABLE_A -t TABLE_B > DB_NAME.dump.sql
```


## Database is corrupt

Prevention is always better than cure. We recommend keeping backups of anything important.

If you break the ownership permissions on PostgreSQL's data folder, try:

```bash
docker compose run --rm --user root --entrypoint chown postgres -R postgres:postgres /var/lib/postgresql
```

You can start from scratch by wiping the `data/postgres/` folder. **This permanently deletes all databases stored there.**

1. Stop the PostgreSQL service: `docker compose stop postgres`
1. Delete and recreate the `data/postgres/` folder
1. Start the service: `docker compose up -d`


## Changing the PostgreSQL password

The `POSTGRES_PASSWORD` setting is only applied when PostgreSQL initializes an empty data directory. Changing it later will not update an existing database. To change the password for the `root` user, connect to PostgreSQL and use `\password`:

```bash
docker compose exec postgres psql -U root
```

Then at the `psql` prompt:

```text
\password root
\q
```
