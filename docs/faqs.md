# FAQs ❓

## <xyz>.localhost isn't working

Most browser (eg. Brave, Microsoft Edge, Google Chrome etc) will automatically detect the .localhost TLD and route to localhost (so you won't need to do anything further). However if you're receiving an error, it could be because your browser isn't doing this (routing the host to localhost).

You can manually tell your machine to route the URL to localhost (127.0.0.1) by editing your machine's host file. The below is an example for UNIX based systems.

```bash
# Open your hosts files (with admin rights)
sudo nano /etc/hosts

# Append each site you need to access - eg.
127.0.0.1 info.localhost
```

---

## How do I setup/run Crons?

Each version of PHP can have it's own CRON's.

1. Simply create a file called `custom_crontab` in the PHP directory of your choice (eg. `/php/74/custom_crontab`). Add your CRON's to this script.
1. Rebuild that PHP container: `docker compose build php74-fpm`
1. And start it up: `docker compose up -d`

Your CRON entries should look something like this:

```
* * * * * php /var/www/html/my-wordpress-site/wp-cron.php
```

The CRON's will only run while your docker containers are running.

---

## How do I get BrowserSync working from inside a container?

BrowserSync works by proxying a host and auto-refreshing the browser when a file was updated. When run from within a container, it needs to proxy the PHP site through the apache container (to get the same result that you see).

We have 2 options for this.

### 1. Adjust your site's config

We have a (wildcard) DNS redirect setup at `*.lde.pvtl.io` which points to the apache container's IP address. This is for convenience, so that our docker container can use that hostname to find the IP. Simply adjust your BrowserSync config to use this hostname:

1. BrowserSync config: Instead of using the hostname `<SITE NAME>.pub.localhost`, use `<SITE NAME>.pub.lde.pvtl.io`
1. (optional) .env: Adjust your site's hostname (usually in `.env`) to use the same `.lde.pvtl.io` alternative
    - Primarily relevant in Wordpress sites, because Wordpress will redirect to `WP_HOME`

### 2. Manually Define

Alternatively, you can manually define where your host is (i.e. what is the hosts IP?). In our case, the IP is that of the `apache` container.

1. `docker exec -it php80-fpm bash` - SSH into the PHP container where you're running `yarn watch` from
1. Find the `apache` containers IP address with `ping -c 1 apache | awk -F '[()]' '{print $2}' | head -n 1`
1. `nano /etc/hosts` - Edit the hosts file, and add `<Apache IP address> <The destination site hostname>` on a new line. eg:
  - `192.168.103.100 wp.pub.localhost`

---

## CURL requests from an LDE site to another LDE site

For instances where you'd like to make a CURL request (or a server-side request) from a site hosted in your LDE, to another site hosted in your LDE (or even to itself), your environment needs to be configured to know where to look.

We need to simply add a host file record of the site we're requesting, pointing to our `apache` container.

1. `docker exec -it php80-fpm bash` - SSH into the PHP container that's running the site
1. Find the `apache` containers IP address with `ping -c 1 apache | awk -F '[()]' '{print $2}' | head -n 1`
1. `nano /etc/hosts` - Edit the hosts file, and add `<Apache IP address> <The destination site hostname>` on a new line. eg:
  - `192.168.103.100 wp.pub.localhost`


---

## How do I use HTTPS/SSL for my local containers?

HTTPS (port 443) is enabled by default, however Apache is using a self-signed certficate so your browser may require you to enable a feature flag:

- `edge://flags` or `chrome://flags` or `brave://flags`...
- Enable: `Allow invalid certificates for resources loaded from localhost.`

---

## How do I use Blackfire?

By default, Blackfire is commented out (as it's not used regularly by everyone). To enable it:

*1. Update your environment*

- Update the environment variables (`BLACKFIRE_CLIENT_ID` etc) in `/.env`
- Add `opt/blackfire.yml` to the `COMPOSE_FILE` list in your .env file (using ":" as list separators). This enables the Blackfire agent container.
- Uncomment the `Install Blackfire` lines in `php/xx/Dockerfile` (where "xx" is the version of PHP you're enabling Blackfire for). This enables the Blackfire extension for PHP.
- Rebuild and restart - `docker compose down && docker compose build --pull --no-cache && docker compose up -d` (this will take a while)

*2. Profile*

- Sign into [blackfire.io](https://blackfire.io)
- Install the [Chrome Blackfire extension](https://chrome.google.com/webstore/detail/blackfire-profiler/miefikpgahefdbcgoiicnmpbeeomffld?utm_source=chrome-ntp-icon)
- Navigate to the page/site you'd like to profile and click the 'Profile' button from the Chrome extension

---

## Mapping a Custom Hostname to a local site

Let's say you want `phpinfo.com` to map to a local site. It's as easy as adding a new conf file to `apache/sites` then rebuilding (`docker compose build apache`) and starting (`docker compose up -d`). The file would looking something like this:

```
DocumentRoot /var/www/html
DirectoryIndex index.html index.php
ServerAdmin tech@pvtl.io

<VirtualHost *:*>
    ServerName phpinfo.com
    ServerAlias phpinfo.com

    UseCanonicalName Off
    VirtualDocumentRoot /var/www/html/info

    <FilesMatch "\.php$">
      SetHandler proxy:fcgi://php74-fpm:9000
    </FilesMatch>
</VirtualHost>
```

_Note that apache will load the conf files in alphabetical order. Because our localhost.conf has a "catch all", any of our custom conf files, must be named alphabetically before localhost.conf_

---

## Changing your MySQL Root password

If data already exists in your MySQL data store (eg. you've started the MySQL container in the past), simply changing the `.env` `MYSQL_ROOT_PASSWORD` will not change the password. Instead, you need to follow the following steps:

- Update `MYSQL_ROOT_PASSWORD` in `.env`, to your new password
- Build, start and exec into your MySQL container: `docker compose exec mysql bash`
- Login to MySQL: `mysql -u root -p`
- Execute the following:

```mysql
use mysql;
update user set authentication_string=password('YOUR_NEW_PASSWORD_HERE') where user='root';
flush privileges;
quit;
```

---

## "Container Name already in use" error

In some instances a build may fail due to a `Container Name already in use` error. You can fix this by following the "update" instructions above. This will recreate a fresh environment from scratch.

---

## Adding custom PHP configuration

Simply add a `/php/conf/custom.ini` file and rebuild `docker compose up -d --build`.
This will take effect in all of your PHP containers.

---

## Using Redis as a session handler

Did you know that PHP sessions will block concurrent requests from the same user, until the first request is finished? You can improve your session save handler performance by switching to Redis.

1. Add the Redis service - i.e. add `opt/redis.yml` to `COMPOSE_FILE` in `.env`
2. Add a `/php/conf/custom.ini` with

```
[PHP]
session.save_handler = redis
session.save_path = "tcp://redis:6379"
```

3. Rebuild `docker compose up -d --build`

---

## How do I change the 'default' PHP container?

Let's say that you primarily use PHP 7.4, and want all websites to use PHP 7.4 (instead of the latest version of PHP) for URLs like `<directory-name>.localhost` and `<directory-name>.pub.localhost`:

1. Ensure the PHP74 image is included in your `/.env`
    - i.e. ensure that `opt/php74` is included in `COMPOSE_FILE`
1. Cut (copy and remove) the `ServerAlias *.pub.*` line from `/apache/sites/pub.localhost/php<LATEST_VERSION>.conf`
    - Paste that line into `/apache/sites/pub.localhost/php74.conf` (after the first `ServerAlias ..` line)
1. Cut (copy and remove) the `ServerAlias *.*` line from `/apache/sites/localhost/php<LATEST_VERSION>.conf`
    - - Paste that line into `/apache/sites/localhost/php74.conf` (after the first `ServerAlias ..` line)
1. Rebuild apache `docker compose build apache`
1. Bring it back up `docker compose up -d`
