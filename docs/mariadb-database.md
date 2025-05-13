# MariaDB

MariaDB is (mostly) a drop-in replacement for MySQL, so you can use the same tools and commands as you would with MySQL.

We use the official [MariaDB](https://hub.docker.com/_/mariadb) image.


## Connecting

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `mysql` (from a container)<br>`localhost` (from your computer) |
| Port | `3306` |
| Username | `root` |
| Password | `dbroot` (this can be changed in `.env`) |

If you're looking for a suitable desktop app, we recommend [TablePlus](https://tableplus.com/) or [MySQL Workbench](https://www.mysql.com/products/workbench/).


## Where is my data stored?

See `mysql/data/`.

All database data is stored on your host machine (not inside the docker container). This makes it simple to update your Docker Dev environment without losing any data.

> Warning: It is very easy to break your database if you touch any files in there. We recommend keeping SQL dumps of anything important.


## Export SQL dumps of databases or tables

We find it more convenient to use a GUI database application to export tables or full databases (like Table Plus), but if you wish, you can dump them from the command line like this:

```bash
# Run from the root folder of "docker-dev"
docker exec -i mysql mariadb-dump -u root -p DB_NAME > DB_NAME.dump.sql
```

The command will prompt you for the root password (ie. `dbroot`).

If you wish to only export specific tables, list them after the database name like so:

```bash
docker exec -i mysql mariadb-dump -u root -p DB_NAME TABLE_A TABLE_B TABLE_C > DB_NAME.dump.sql
```


## Database is corrupt

Prevention is always better than cure. We recommend keeping backups of anything important.

If you break the ownership permissions on MariaDB's "data" folder, try:

```bash
docker compose run mysql chown -R root:mysql /var/lib/mysql/*
```

You can start from scratch by wiping the `mysql/data/` folder:

1. Stop all containers: `docker compose stop`
1. Delete the `mysql/data/` folder
1. Recreate the `mysql/data/` folder
1. Start all containers: `docker compose up -d`

The database's first boot will take longer than usual (ie. 30 seconds).


## Changing the root password

If you have previously used MariaDB then simply changing `MYSQL_ROOT_PASSWORD` in `.env` will not work. Instead, you will need to:

1. Update `MYSQL_ROOT_PASSWORD` in `.env`, to your new password
1. Build, start and exec into your MariaDB container: `docker compose exec mysql bash`
1. Log into MariaDB using the old password: `mysql -u root -p`
1. Execute the following:

```sql
use mysql;
update user set authentication_string=password('YOUR_NEW_PASSWORD_HERE') where user='root';
flush privileges;
quit;
```
