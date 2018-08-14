# A LAMP Local Development Environment on Docker

__An everyday local development environment for PHP Developers.__ At [Pivotal Agency](https://pivotal.agency), we've done a _buuunnnch_ of R&D to find the best local dev tools for our team. This is the result of our hard work. This tool has been put to its paces everyday by our team, we hope it can also help yours.

---

## Intro 👋

This is a set of Docker images to spin up a LAMP stack (Linux, Apache, MySQL and PHP) for developing locally. It's perfect for local development because you can very simply add new sites to specified directory and they're magically accessible as a subdomain of your chosen hostname (eg. eg. `~/Sites/info` maps to `http://info.localhost/`).

It includes all the required dependencies for everyday PHP development with common tools like Laravel, Wordpress and Magento (1 & 2).

Specifically, it has the following tech available:

* PHP 5.6, 7.0 and 7.2
* MySQL 5.7
* Redis 4.x
* Memcached 1.x
* Composer (latest)
* NodeJS (10.x) & NPM (4.x)
* Mailhog (latest)
* [Blackfire](https://blackfire.io/) (latest)

We have some clever domain mapping available to allow you to run code for various platforms. Sites are accessible from the following URLs (by default it's `http://<website>.localhost`, however `APACHE_HOSTNAME` can modified in `.env` to point to a different hostname):

* __http://classic-php.php56.{APACHE_HOSTNAME}__ (eg. http://classic-php.php56.localhost)
    * Will map to `~/Sites/classic-php` and use PHP 5.6
* __http://laravel.php70.pub.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/laravel/public` and use PHP 7.0
* __http://another-project.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/another-project` and use the default version of PHP (currently 7.2)

---

## Prerequisites ⚠️

* Your machine must be MacOS, Windows 10 _Pro_ or Linux
* Your CPU must support virtualisation (Intel VT-x or AMD-V)
* You must have [Docker Compose installed](https://docs.docker.com/compose/install/) and Docker installed & running

---

## Installation 🚀

```bash
# Clone the repo
git clone https://github.com/pvtl/docker-dev && cd docker-dev

# Create & update relevant config (eg. point sites to your sites directory)
cp .env.example .env

# Start the environment
docker-compose up -d
```

__(Optional)__ If you're doing local development at _.localhost_ for example, you may need to update your computer's hosts file to point each URL to `127.0.0.1`. Eg.

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
git pull                                  # 1. Pull from Git
docker-compose down --remove-orphans      # 2. Erase previous containers
docker-compose pull                       # 3. Get latest docker images
docker-compose up -d --build --no-cache   # 4. Rebuild & start the new env
```

*This will also install the latest versions of PHP, Redis, NodeJS and NPM.

### Important Breaking Changes

* The MySQL hostname and container name has changed from `db` to `mysql`. This enables us to add other DB's in the future without the naming convention getting confusing (eg. MongoDB, PostgreSQL).
* PHP 7.2 and Apache server have been separated into their own containers (`php72-fpm` and `apache` respectively).
* PHP 5 is now PHP 5.6 specifically. The URL has changed to: `<project>.php56.localhost`
* You can use `<project>.pub.localhost` (Laravel) URL's with any PHP version now. Eg: `<project>.php56.pub.localhost`
* We recommend you specify a PHP version number in the URL's of your projects rather than rely on the default. It's currently PHP 7.2, but this may change in the future.


---

## Common Commands 🔥

The Docker Engine must be running and commands must be run within this repo's root.

| Command | Description |
|---|---|
| `docker-compose start` | Start all containers |
| `docker-compose stop`  | Stop all containers (keeps any config changes you've made to the containers) |
| `docker-compose up -d --build --no-cache` | Recreate all containers from scratch |
| `docker-compose down`  | Tear down all containers (MySQL data and Project files are kept) |
| `docker-compose logs php71-fpm` | View all logs for PHP-FPM 7.2 |
| `docker exec -it php71-fpm bash`  | SSH into PHP 7.2 container |
| `docker exec -it mysql bash`  | SSH into Database container |
| `docker ps` | Show which containers are running |
---

## Connections 🚥

### Email
All email is sent from the application and "caught" by [Mailhog](https://github.com/mailhog/MailHog). This means that the application will send the mail, just not out to a real email. This is helpful in development, so that others aren't spammed by test emails.

You can view anything which has been sent and caught via [http://localhost:8025/](http://localhost:8025/).

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

## Troubleshooting ❓

In some instances a build may fail due to a `Container Name already in use` error. You can fix this by following the "update" instructions above. This will recreate a fresh environment from scratch.
