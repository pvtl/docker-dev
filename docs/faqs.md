# FAQs ❓

## How do I setup/run Crons?

Each version of PHP can have it's own CRON's.

1. Simply create a file called `custom_crontab` in the PHP directory of your choice (eg. `/php/74/custom_crontab`). Add your CRON's to this script.
1. Rebuild that PHP container: `docker-compose build php74-fpm`
1. And start it up: `docker-compose up -d`

Your CRON entries should look something like this:

```
* * * * * php /var/www/html/my-wordpress-site/wp-cron.php
```

The CRON's will only run while your docker containers are running.

---

## "Container Name already in use" error

In some instances a build may fail due to a `Container Name already in use` error. You can fix this by following the "update" instructions above. This will recreate a fresh environment from scratch.

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

1. `docker exec -it php74-fpm bash` - SSH into the container where you're running `yarn watch` from
1. `nano /etc/hosts` - Edit the hosts file
    - `192.168.103.1 <THIS SITE URL eg. wp.pub.localhost>` - Add the current site's URL, pointing to the `apache` container
    - You can find the apache containers IP with `ping -c 1 apache | awk -F '[()]' '{print $2}' | head -n 1`

---

## How do I use HTTPS/SSL for my local containers?

We have a HTTPS container available, that proxies traffic over https (:443) (with a self signed certificate) to/from your localhost port 80 addresses.

By default this container is commented out (as it's not used regularly by everyone). To enable it:

- Add the container - Uncomment the `https` container in `/docker-compose.yml`
- Rebuild and restart - `docker-compose build --pull --no-cache https && docker-compose up -d`

Note that Chrome/Edge may require you to enable a feature flag, to access the site with an insecure (self signed) certificate:

- `edge://flags` or `chrome://flags`
- Enable: `Allow invalid certificates for resources loaded from localhost.`

---

## How do I use Blackfire?

By default, Blackfire is commented out (as it's not used regularly by everyone). To enable it:

*1. Update your environment*

- Update the environment variables (`BLACKFIRE_CLIENT_ID` etc) in `/.env`
- Add the container - Uncomment the `blackfire` container in `/docker-compose.yml`
- Add the PHP module - Uncomment the `Blackfire PHP Profiler...` block in `/php/shared.sh`
- Rebuild and restart - `docker-compose down && docker-compose build --pull --no-cache && docker-compose up -d` (this will take a while)

*2. Profile*

- Sign into [blackfire.io](https://blackfire.io)
- Install the [Chrome Blackfire extension](https://chrome.google.com/webstore/detail/blackfire-profiler/miefikpgahefdbcgoiicnmpbeeomffld?utm_source=chrome-ntp-icon)
- Navigate to the page/site you'd like to profile and click the 'Profile' button from the Chrome extension
