# A LAMP Local Development Environment on Docker

__An everyday local development environment for PHP Developers.__ At [Pivotal Agency](https://pivotal.agency), we've done a _buuunnnch_ of R&D to find the best local dev tools for our team. This is the result of our hard work. This tool has been put to its paces everyday by our team, we hope it can also help yours.

---

## Intro 👋

This is a set of Docker images to spin up a LAMP stack (Linux, Apache, MySQL and PHP) for developing locally. It's perfect for local development because you can very simply add new sites to specified directory and they're magically accessible as a subdomain of your chosen hostname (eg. eg. `~/Sites/info` maps to `http://info.localhost/`).

It includes all the required dependencies for everyday PHP development with common tools like Laravel, Wordpress and Magento (1 & 2).

Specifically, it has the following tech available:

* PHP 5.6, 7.0, 7.1, 7.2 and 7.3
* MySQL 5.7
* Redis 4.x
* Memcached 1.x
* Composer (latest)
* NodeJS (10.x) & NPM (latest)
* Yarn (latest)
* Mailhog (latest)
* [Blackfire](https://blackfire.io/) (latest)

We have some clever domain mapping available to allow you to run code for various platforms. Sites are accessible from the following URLs (by default it's `http://<website>.localhost`, however `APACHE_HOSTNAME` can modified in `.env` to point to a different hostname):

* __http://classic-php.php56.{APACHE_HOSTNAME}__ (eg. http://classic-php.php56.localhost)
    * Will map to `~/Sites/classic-php` and use PHP 5.6
* __http://laravel.php70.pub.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/laravel/public` and use PHP 7.0
* __http://another-project.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/another-project` and use the default version of PHP (currently 7.3)

---

## Prerequisites ⚠️

* Your machine must be running MacOS, Windows 10 _Pro_ or Linux
* Your CPU must support virtualisation (Intel VT-x or AMD-V)
* You must have [Docker Compose installed](https://docs.docker.com/compose/install/) and Docker installed & running

---

## Installation 🚀

```bash
# Clone the repo
git clone https://github.com/pvtl/docker-dev && cd docker-dev

# Create & update relevant config (eg. point sites to your sites directory)
cp .env.example .env

# Start the environment and go get a ☕️ (it'll take a while to install e'ry-thing)
docker-compose up -d
```

__Then, for each website, simply point the URL to localhost (127.0.0.1):__

```bash
# Open your hosts files (with admin rights)
sudo nano /etc/hosts

# Append each site you need to access - eg.
127.0.0.1 info.localhost
```

---

## Updating 🔄

Open a terminal window, browse to this project's folder and run:

```bash
git pull                                        # 1. Pull from Git
docker-compose down --remove-orphans            # 2. Erase previous containers
docker-compose pull                             # 3. Get latest docker images
docker-compose build --pull --no-cache          # 4. Rebuild Dockerfiles from scratch (inc. pull parent images)
docker-compose up -d                            # 5. Start the new env
```

*This will also install the latest versions of PHP, Redis, NodeJS and NPM.*

---

## Common Commands 🔥

The Docker Engine must be running and commands must be run within this repo's root.

| Command | Description |
|---|---|
| `docker-compose start` | Start all containers |
| `docker-compose stop`  | Stop all containers (keeps any config changes you've made to the containers) |
| `docker-compose up -d --build --no-cache` | Recreate all containers from scratch |
| `docker-compose down`  | Tear down all containers (MySQL data and Project files are kept) |
| `docker-compose exec php73-fpm bash`  | Open a bash terminal in the PHP 7.3 container |
| `docker-compose logs php73-fpm` | View all logs for PHP-FPM 7.3 |
| `docker-compose ps` | Show which containers are running |
| `docker system prune --volumes` | Erase any unused containers, images, volumes etc. to free disk space. |
---

## Connections 🚥

### Email
By default all email sent from PHP is "caught" by [Mailhog](https://github.com/mailhog/MailHog). This allows you to review the emails being sent without the system actually delivering them to real email addresses.

You can view anything which has been sent and caught via [http://localhost:8025/](http://localhost:8025/).

| Parameter | Value |
|-------------|---|
| Host | `mailhog` |
| Port | `1025` |
| Username | `testuser` |
| Password | `testpwd` |

### MySQL
You can connect to the MySQL server running in the container using [MySQL Workbench](https://www.mysql.com/products/workbench/), [Navicat](https://www.navicat.com/) or [Sequel Pro](https://www.sequelpro.com/).

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `mysql` (from a container) OR `localhost` (from your computer) |
| Port | `3306` |
| Username | `root` |
| Password | `dbroot` (this can be changed in `.env`) |

Alternatively you can add `127.0.0.1 mysql` to your hosts file so that the `mysql` hostname will work either from your host machine or from the docker containers (useful for CLI tools like Laravel's `artisan` command).

### Xdebug

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

### Redis
You can connect to the Redis server with:

| Parameter | Value |
|-------------|---|
| Host | `redis` (from a container) OR `localhost` (from your computer) |
| Port | `6379` |
| Password | `` |

### Memcached
You can connect to the Memcached server with:

| Parameter | Value |
|-------------|---|
| Host | `memcached` (from a container) OR `localhost` (from your computer) |
| Port | `11211` |

---

## FAQs ❓

### How do I setup/run Crons?

Each version of PHP can have it's own CRON's.

1. Simply create a file called `custom_crontab` in the PHP directory of your choice (eg. `/php/73/custom_crontab`). Add your CRON's to this script.
1. Rebuild that PHP container: `docker-compose build php73-fpm`
1. And start it up: `docker-compose up -d`

Your CRON entries should look something like this:

```
* * * * * php /var/www/html/my-wordpress-site/wp-cron.php
```

The CRON's will only run while your docker containers are running.

### "Container Name already in use" error

In some instances a build may fail due to a `Container Name already in use` error. You can fix this by following the "update" instructions above. This will recreate a fresh environment from scratch.

### How do I get BrowserSync working from inside a container?

To run BrowserSync from within a container, it needs to proxy a PHP site to generate the site. To do this, it needs to know where the URL lives (which, from the outside world, is through the `apache` container).

Note: BrowserSync will only work from within the `php73-fpm` container.

1. `docker exec -it php73-fpm bash` - SSH into the PHP7.3 container
1. `nano /etc/hosts` - Edit the hosts files
    - `171.22.0.10 <THIS SITE URL eg. wp.pub.localhost>` - Add the current site's URL, pointing to the `apache` container

Now you can run `npm start` and you'll be able to access the BrowserSync version of the site at `<THIS SITE URL>:3000`

---

## Breaking Changes ⚠️

* The MySQL hostname and container name has changed from `db` to `mysql`. This enables us to add other DB's in the future without the naming convention getting confusing (eg. MongoDB, PostgreSQL).
* PHP 7.1 and Apache server have been separated into their own containers (`php71-fpm` and `apache` respectively).
* PHP 5 is now PHP 5.6 specifically. The URL has changed to: `<project>.php56.localhost`
* You can use `<project>.pub.localhost` (Laravel) URL's with any PHP version now. Eg: `<project>.php56.pub.localhost`
* We recommend you specify a PHP version number in the URL's of your projects rather than rely on the default. It's currently PHP 7.1, but this may change in the future.
