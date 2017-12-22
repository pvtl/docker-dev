# Pivotal Docker Environment

This is a set of Docker images to spin up a LAMP stack (Linux, Apache, MySQL and PHP) in one simple command. It's perfect for local development or even as a staging server, as you can very simply add new sites to a root directory, and they're magically accessible as a subdomain of your chosen hostname (eg. `http://info.localhost/`).

It includes all the required dependencies for everyday PHP development. Everything from Laravel and Wordpress to Magento (1 & 2).

Specifically, it has the following tech available:

* Debian Jessie
* PHP 7.1.x (default) and PHP 5.6.X
* MySQL 5.7
* Redis 3.x
* Memcached
* Composer
* NodeJS & NPM
* Blackfire (for PHP performance testing)

We have some clever domain mapping available to allow you to run code for various platforms. Sites are accessible from the following URLs (by default it's `http://<website>.localhost`, however `APACHE_HOSTNAME` can modified in `.env` to point to a different hostname):

* __http://info.{APACHE_HOSTNAME}__ (eg. http://info.localhost)
    * Will map to `~/Sites/info`
* __http://laravel.pub.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/laravel/pub`
* __http://sitehq.php5.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/sitehq` and use PHP5

## Prerequisites

* Your machine must be MacOS, Windows 10 _Pro_ or Linux
* Your CPU must support virtualisation (Intel VT-x or AMD-V)
* You must have [Docker Compose installed](https://docs.docker.com/compose/install/) and Docker running

## Installing

1. Clone this repo
1. Create an environment file and configure for your environment `cp .env.example .env`
    - __Where do your sites live?__ - Change `DOCUMENTROOT` to the absolute path on your machine, where 'all the websites' live
        - _eg. inside my `~/Sites/` folder I have a folder called `info`, which I can access at `https://info.localhost/`_
    - __What is your hostname?__ - Update `APACHE_HOSTNAME`
        - _eg. you could change it to `devserver.com` making the website in directory `~/Sites/wordpress` automatically accesible at `http://wordpress.devserver.com`_
1. Run `docker-compose up -d` from the root directory of this repo
    - _This will download dependencies for the container and set it up from scratch. The first time running this will take a few minutes, after that, a few seconds_

__(Optional)__ If you're doing local development at _.localhost_ for example, you may need to update your computer's hosts file to point each URL to `127.0.0.1` - eg: `127.0.0.1 info.localhost`.

## Updating

Open a terminal window, browse to this project's folder and run:

```
git pull;
docker-compose down;
docker-compose build;
docker-compose up -d;
```

This will also install the latest versions of PHP, Redis, NodeJS and NPM.

## Common Commands

* Docker must be running
* Commands should be run within this repo's root

| Command | Description |
|---|---|
| `docker-compose up -d` | Start |
| `docker-compose down`  | Stop |
| `docker exec -it web bash`  | SSH into web container |
| `docker exec -it db bash`  | SSH into Database container |
| `docker ps` | Show which containers are running |

---

## Connections

### MySQL
You can connect to the MySQL server running in the container using [MySQL Workbench](https://www.mysql.com/products/workbench/), [Navicat](https://www.navicat.com/) or [Sequel Pro](https://www.sequelpro.com/).

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `db` (from a container) OR `localhost` (from your computer) |
| Port | `3306` |
| Username | `root` |
| Password | `dbroot` (this can be changed in `.env`) |

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
