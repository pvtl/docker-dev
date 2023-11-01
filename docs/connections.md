# Connections 🚥

## Email / SMTP
When PHP sends emails using sendmail or SMTP, it's automatically "caught" by [Mailpit](https://github.com/axllent/mailpit). This enables you to review the emails without delivering them to real email addresses.

You can view anything which has been caught at [http://localhost:8025/](http://localhost:8025/).

You can configure SMTP clients to send emails to Mailpit using:

| Parameter | Value |
|-------------|---|
| Host | `mailpit` (from a container)<br>`localhost` (from your computer) |
| Port | `1025` |

Sometimes it's useful to have the "mailpit" hostname work either from your host machine or from the docker containers (eg. CLI tools like Laravel's artisan command). Simply add `127.0.0.1 mailpit` to your hosts file. Not sure how? [See our FAQ's](faqs.md).


## MariaDB / MySQL Database
You can connect to the MariaDB server using any client.

If you're looking for a suitable desktop app, we recommend [TablePlus](https://tableplus.com/) or [MySQL Workbench](https://www.mysql.com/products/workbench/).

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `mysql` (from a container)<br>`localhost` (from your computer) |
| Port | `3306` |
| Username | `root` |
| Password | `dbroot` (this can be changed in `.env`) |

Sometimes it's useful to have the "mysql" hostname work either from your host machine or from the docker containers (eg. CLI tools like Laravel's artisan command). Simply add `127.0.0.1 mysql` to your [hosts file](https://www.hostinger.com/tutorials/how-to-edit-hosts-file).

QUICK FIX: If you ever break the ownership settings on MariaDB's "data" folder, simply exec into the MariaDB container and run:
`chown -R root:mysql /var/lib/mysql/*`


## Redis
You can connect to the Redis server with:

| Parameter | Value |
|-------------|---|
| Host | `redis` (from a container) OR `localhost` (from your computer) |
| Port | `6379` |
| Password | `` |


## Memcached
You can connect to the Memcached server with:

| Parameter | Value |
|-------------|---|
| Host | `memcached` (from a container) OR `localhost` (from your computer) |
| Port | `11211` |
