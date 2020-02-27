# Connections 🚥

## Email
By default all email sent from PHP is "caught" by [Mailhog](https://github.com/mailhog/MailHog). This allows you to review the emails being sent without the system actually delivering them to real email addresses.

You can view anything which has been sent and caught via [http://localhost:8025/](http://localhost:8025/).

| Parameter | Value |
|-------------|---|
| Host | `mailhog` |
| Port | `1025` |
| Username | `testuser` |
| Password | `testpwd` |

---

## MySQL
You can connect to the MySQL server running in the container using [MySQL Workbench](https://www.mysql.com/products/workbench/), [Navicat](https://www.navicat.com/) or [Sequel Pro](https://www.sequelpro.com/).

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `mysql` (from a container) OR `localhost` (from your computer) |
| Port | `3306` |
| Username | `root` |
| Password | `dbroot` (this can be changed in `.env`) |

Alternatively you can add `127.0.0.1 mysql` to your hosts file so that the `mysql` hostname will work either from your host machine or from the docker containers (useful for CLI tools like Laravel's `artisan` command).

---

## Xdebug

> **NOTE**: This feature requires Docker 18.03 or later

Xdebug has been installed and configured, but it's disabled by default as it makes everything run much slower!

You can enable Xdebug as-needed by exec'ing into the desired PHP container, moving the Xdebug config file into place, and restarting that container:

```
docker-compose exec php71-fpm bash
mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
docker-compose restart php71-fpm
```

To disable Xdebug again, simply reverse the process:

```
docker-compose exec php71-fpm bash
mv /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini.DISABLE
docker-compose restart php71-fpm
```

Xdebug expects the debugging client (eg. PHPStorm) to be running on port `9000` of the Docker host machine.

If you're using PHPStorm follow the [remote debug (docker) setup guide](https://www.jetbrains.com/help/phpstorm/configuring-remote-php-interpreters.html#d36845e650).

The easiest way to trigger a debugging session is to use this [Google Chrome extension](https://chrome.google.com/webstore/detail/xdebug-helper/eadndfjplgieldjbigjakmdgkmoaaaoc). Just enable debug mode in the extension, set a breakpoint in the code and reload the page.

If you're using Postman, cURL or another HTTP client simply send `XDEBUG_SESSION_START=session_name` as a GET or POST parameter.

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
