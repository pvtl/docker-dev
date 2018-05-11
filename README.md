# A LAMP Local Development Environment on Docker

__An everyday local development environment for PHP Developers.__ At [Pivotal Agency](https://pivotal.agency), we've done a _buuunnnch_ of R&D to find the best local dev tools for our team. This is the result of our hard work. This tool has been put to its paces everyday by our team, we hope it can also help yours.

---

## Intro 👋

This is a set of Docker images to spin up a LAMP stack (Linux, Apache, MySQL and PHP) for developing locally. It's perfect for local development because you can very simply add new sites to specified directory and they're magically accessible as a subdomain of your chosen hostname (eg. eg. `~/Sites/info` maps to `http://info.localhost/`).

It includes all the required dependencies for everyday PHP development with common tools like Laravel, Wordpress and Magento (1 & 2).

Specifically, it has the following tech available:

* Debian Jessie
* PHP 7.1.x (default) and PHP 5.6.X
* MySQL 5.7
* Redis 3.x
* Memcached
* Composer
* NodeJS & NPM
* Mailhog
* Blackfire (for PHP performance testing)

We have some clever domain mapping available to allow you to run code for various platforms. Sites are accessible from the following URLs (by default it's `http://<website>.localhost`, however `APACHE_HOSTNAME` can modified in `.env` to point to a different hostname):

* __http://info.{APACHE_HOSTNAME}__ (eg. http://info.localhost)
    * Will map to `~/Sites/info`
* __http://laravel.pub.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/laravel/pub`
* __http://sitehq.php5.{APACHE_HOSTNAME}__
    * Will map to `~/Sites/sitehq` and use PHP5

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
git pull                        # 1. Pull from Git
docker-compose up -d --build    # 2. Rebuild & start the new env
```

*This will also install the latest versions of PHP, Redis, NodeJS and NPM.


---

## Common Commands 🔥

Docker must be running and commands should be run within this repo's root.

| Command | Description |
|---|---|
| `docker-compose up -d` | Start |
| `docker-compose down`  | Stop |
| `docker exec -it web bash`  | SSH into web container |
| `docker exec -it db bash`  | SSH into Database container |
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


---

## Troubleshooting ❓

In some instances a build may fail due to a "Container Name already in use" error. You can overcome this issue by explicitly removing all of the containers. Run:


```bash
docker stop <containername>     # 1. Make sure the container is not running
docker rm <containername>     # 2. Remove the container explicitly
docker-compose up -d --build    # 3. Rebuild & start the new env
```

*The `stop` and `rm` commands allow you to reference multiple containers at once by adding spaces between the container names.


