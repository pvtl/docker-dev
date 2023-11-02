# PHP

We use the [official PHP Docker images](https://hub.docker.com/_/php) and add a few extra features to make them nicer for everyday use.


## Which versions are available?
We offer 5.6, all 7.x and all 8.x.

See the `/php` and `/php/src` folders for more details.


## How do I use a specific version?
Name the version you want in the URL.

eg. `https://<folder>.php82.localhost` will use PHP 8.2.


# Why is `<xyz tool>` missing?

Only the latest version of PHP has these tools installed:

- Node.js (latest LTS) & NPM (latest)
- Yarn (latest of 1.x)
- PHPCS (with Wordpress code standards added)
- Wordpress CLI
- ZSH

All other PHP containers will only have Composer installed.

This was a deliberate decision in order to keep the PHP containers as small as possible, but still provide the convenience of having these tools available.

If you want to install your own tools then see "How can I customise my containers?" in the [General FAQ](general-faq.md).


## How do I run CRONs?

Each version of PHP can have it's own scheduled CRON jobs.

1. Create a file called `custom_crontab` in the PHP folder of your choice (eg. `php/82/custom_crontab`).
1. Add your scheduled commands into `custom_crontab`
1. Rebuild that PHP image (eg. for PHP 8.2): `docker compose build php82-fpm`
1. Use the new image: `docker compose up -d`

Your CRON entries should look something like this:

```
* * * * * cd /var/www/html/my-laravel-site/ && php artisan schedule:run >> /dev/null 2>&1
```

CRONs will only run while your Docker Dev containers are running.


## How do I get BrowserSync working from inside a container?

BrowserSync works by proxying a host and auto-refreshing the browser when a file was updated. When run from within a container, it needs to proxy the PHP site through the apache container (to get the same result that you see).

We have 2 options for this.

### 1. Adjust your site's config

We have a (wildcard) DNS redirect setup at `*.lde.pvtl.io` which points to the apache container's IP address. This is for convenience, so that our docker container can use that hostname to find the IP. Simply adjust your BrowserSync config to use this hostname:

1. BrowserSync config: Instead of using the hostname `<folder>.pub.localhost`, use `<folder>.pub.lde.pvtl.io`
1. (optional) .env: Adjust your site's hostname (usually in `.env`) to use the same `.lde.pvtl.io` alternative
    - Primarily relevant in Wordpress sites, because Wordpress will redirect to `WP_HOME`

### 2. Adjust the hosts file (inside the container)

Follow the instructions in the section below (HTTP requests from one LDE site to another).


## HTTP requests from one LDE site to another

By default, you cannot send cURL, Wget or other HTTP requests from one site in your LDE to another (or itself). The PHP containers (where the HTTP requests are sent from) don't know which IP to use for `https://<folder>.localhost`.

You can work around this issue by editing the hosts file inside the PHP container which is sending the request, and manually tell it the IP to use.

Note, we always use the IP address of the `apache` container since it handles all HTTP requests.

1. Exec into the PHP container (the source of the HTTP request): `docker compose exec php82-fpm bash`
1. Find the IP address of the `apache` container: `ping -c 1 apache | awk -F '[()]' '{print $2}' | head -n 1`
1. Edit the hosts file: `nano /etc/hosts`
1. Append to the end `192.168.103.100   wp.pub.localhost` (adjust the destination hostname to suit)


## Customising PHP (.ini)

1. Add your settings into `php/conf/custom.ini`
1. Rebuild and restart all containers `docker compose up -d --build`.

Your config changes will take effect in all PHP containers.


## Using Redis as a session handler

Did you know that PHP sessions will block concurrent requests (for the same session) until the first request is finished? This is done to prevent race conditions when writing to the session file.

You can improve your concurrency performance (at the risk of race conditions) by using Redis as your session handler.

1. Enable the Redis service by adding `opt/redis.yml` to the `COMPOSE_FILE` list in `.env`
2. Create a `php/conf/custom.ini` file (if it doesn't already exist)
3. Append the following lines

```
[PHP]
session.save_handler = redis
session.save_path = "tcp://redis:6379"
```

4. Rebuild `docker compose up -d --build`


## How do I change the default version of PHP?

The default version of PHP in Docker Dev is typically the latest stable version.

But perhaps you want to use PHP 7.4 for all URLs which do not specify a PHP version (like `<folder>.localhost` and `<folder>.pub.localhost`).

1. Ensure the PHP 7.4 image (`opt/php74.yml`) is added to the `COMPOSE_FILE` list in `.env`
1. Cut the `ServerAlias *.pub.*` line from `apache/sites/pub.localhost/php<LATEST_VERSION>.conf`
1. Paste into `apache/sites/pub.localhost/php74.conf` (after the first `ServerAlias ..` line)
1. Cut the `ServerAlias *.*` line from `apache/sites/localhost/php<LATEST_VERSION>.conf`
1. Paste into `apache/sites/localhost/php74.conf` (after the first `ServerAlias ..` line)
1. Rebuild Apache `docker compose build apache`
1. Bring it back up `docker compose up -d`
