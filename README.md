# Pivotal Docker Environment

This will create a docker container for local development. The build currently includes all the dependencies for Laravel, Wordpress & Magento (1 & 2):

* Debian Jessie
* PHP 7.0.x
* MySQL 5.7
* Redis 3.x
* Memcached
* NodeJS & NPM (latest)

## Prerequisites

* A machine with MacOS, Windows 10 Pro or Linux
* Your CPU must also support virtualisation (Intel VT-x or AMD-V)

## Installation

1. [Install Docker Compose](https://docs.docker.com/compose/install/)
1. Clone this repo
1. Modify `docker-compose.yml` at the line: `- ~/Sites/:/var/www/html/`. Change `~/Sites/` to be your folder containing all of your local projects.
    - _For example, inside my `~/Sites/` folder I have a folder called `vast`. After following these steps, I will be able to visit `vast.dev` and it will run the files contained in the `vast` folder._
1. From the root directory of this repo, run `docker-compose up -d`.
    - _This will download dependencies for the container and set it up from scratch. The first time running this will take a few minutes, after that, a few seconds._
1. For sites to be accessible in the browser at `<directory-name>.dev` - modify your hosts file to point each url to `127.0.0.1`, eg:
    - `127.0.0.1 vast.dev`
    - _or `127.0.0.1 laravel.pub.dev` when you need the document root to be the `/public` directory (see note below)._

## Updating

Keeping your environment up to date is easy. Open a terminal window, browse to this project folder and run:

```
git pull;
docker-compose down;
docker-compose build;
docker-compose up -d;
```

This will install the latest versions of PHP, Redis, NodeJS and NPM.

---

## Connections

### SSH
You can SSH into any container by referencing the container name.

```
# Web container
docker exec -it pvtl-web bash

# DB container
docker exec -it pvtl-db bash
```

### MySQL
You can connect to the MySQL server running in the container using [MySQL Workbench](https://www.mysql.com/products/workbench/), [Navicat](https://www.navicat.com/) or [Sequel Pro](https://www.sequelpro.com/).

| Parameter | Value |
|-------------|---|
| Connection | Standard TCP/IP |
| Host | `db` (from a container) OR `localhost` (from your computer) |
| Port | `3306` |
| Username | `root` |
| Password | `dbroot` |

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
