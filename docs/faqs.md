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

To run BrowserSync from within a container, it needs to proxy a PHP site to generate the site. To do this, it needs to know where the URL lives (which, from the outside world, is through the `apache` container).

Note: BrowserSync will only work from within the `php74-fpm` container.

1. `docker exec -it php74-fpm bash` - SSH into the PHP7.4 container
1. `nano /etc/hosts` - Edit the hosts files
    - `171.22.0.10 <THIS SITE URL eg. wp.pub.localhost>` - Add the current site's URL, pointing to the `apache` container

Now you can run `npm start` and you'll be able to access the BrowserSync version of the site at `<THIS SITE URL>:3000`

---

## How do I use Blackfire?

By default, Blackfire is commented out (as it's not used regularly by everyone). To enable it:

*1. Update your environment*

- Update the environment variables (`BLACKFIRE_CLIENT_ID` etc) in `/.env`
- Add the container - Uncomment the `blackfire` container in `/docker-compose.yml`
- Add the PHP module - Uncomment the `Blackfire PHP Profiler...` block in `/php/shared-all.sh`
- Rebuild and restart - `docker-compose down && docker-compose build --pull --no-cache && docker-compose up -d` (this will take a while)

*2. Profile*

- Sign into [blackfire.io](https://blackfire.io)
- Install the [Chrome Blackfire extension](https://chrome.google.com/webstore/detail/blackfire-profiler/miefikpgahefdbcgoiicnmpbeeomffld?utm_source=chrome-ntp-icon)
- Navigate to the page/site you'd like to profile and click the 'Profile' button from the Chrome extension
