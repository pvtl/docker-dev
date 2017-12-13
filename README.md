# Pivotal Docker Environment

This will create a docker container for local development. The build currently includes all the dependencies for Laravel, Wordpress & Magento (1 & 2):

* Debian Jessie
* PHP 7.0.x
* MySQL 5.7
* Redis 3.x
* Memcached
* Composer
* NodeJS & NPM (latest)

## Prerequisites

* A machine with MacOS, Windows 10 Pro or Linux
* Your CPU must also support virtualisation (Intel VT-x or AMD-V)

## Installation

1. [Install Docker Compose](https://docs.docker.com/compose/install/)
1. Clone this repo
1. Modify `docker-compose.yml` at the line: `- ~/Sites/:/var/www/html/`. Change `~/Sites/` to be your folder containing all of your local projects
    - _For example, inside my `~/Sites/` folder I have a folder called `vast`. After following these steps, I will be able to visit `vast.dev` and it will run the files contained in the `vast` folder._
1. From the root directory of this repo, run `docker-compose up -d`
    - _This will download dependencies for the container and set it up from scratch. The first time running this will take a few minutes, after that, a few seconds_
1. For sites to be accessible in the browser at `<directory-name>.dev` - modify your hosts file to point each url to `127.0.0.1`, eg:
    - `127.0.0.1 vast.dev`
    - _or `127.0.0.1 laravel.pub.dev` when you need the document root to be the `/public` directory_

## Updating

Keeping your environment up to date is easy. Open a terminal window, browse to this project folder and run:

```
git pull;
docker-compose down;
docker-compose build;
docker-compose up -d;
```

This will also install the latest versions of PHP, Redis, NodeJS and NPM.

## Commands

* Docker must be running
* Commands must be run within this repo's root

| Command | Description |
|---|---|
| `docker-compose up -d` | Start |
| `docker-compose down`  | Stop |
| `docker exec -it pvtl-web bash`  | SSH into web container |
| `docker exec -it pvtl-db bash`  | SSH into Database container |

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
