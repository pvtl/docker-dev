# Connections 🚥

## Email
By default all email sent from PHP is "caught" by [Mailpit](https://github.com/axllent/mailpit). This allows you to review the emails being sent without the system actually delivering them to real email addresses.

You can view anything which has been sent and caught via [http://localhost:8025/](http://localhost:8025/).

| Parameter | Value |
|-------------|---|
| Host | `mailpit` (from a container)<br>`localhost` (from your computer) |
| Port | `1025` |

Alternatively you can add `127.0.0.1 mailpit` to your hosts file so the "mailpit" hostname will work either from your host machine or from the docker containers (useful for CLI tools like Laravel's artisan command).

---

## MySQL
You can connect to the MySQL server running in the container using [MySQL Workbench](https://www.mysql.com/products/workbench/), [Navicat](https://www.navicat.com/) or [Sequel Pro](https://www.sequelpro.com/).

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `mysql` (from a container)<br>`localhost` (from your computer) |
| Port | `3306` |
| Username | `root` |
| Password | `dbroot` (this can be changed in `.env`) |

Alternatively you can add `127.0.0.1 mysql` to your hosts file so the "mysql" hostname will work either from your host machine or from the docker containers (useful for CLI tools like Laravel's `artisan` command).

QUICK FIX: If you ever break the ownership settings on your Docker MariaDB Data folder, simply exec into the mysql container and run the foloowing command:
`chown -R root:mysql /var/lib/mysql/*`

---

## Redis
You can connect to the Redis server with:

| Parameter | Value |
|-------------|---|
| Host | `redis` (from a container) OR `localhost` (from your computer) |
| Port | `6379` |
| Password | `` |

---

## Memcached
You can connect to the Memcached server with:

| Parameter | Value |
|-------------|---|
| Host | `memcached` (from a container) OR `localhost` (from your computer) |
| Port | `11211` |
