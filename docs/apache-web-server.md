# Apache

We use the official [Apache](https://hub.docker.com/_/httpd) image and apply some light customisations on top (ie. enabling modules).


## `<folder>.test` is not working

Double-check your Docker Dev containers are running and that you've completed the [DNS Setup](dns-setup.md) for your operating system.

The `.test` TLD requires a one-time DNS configuration on your local machine. Follow the [DNS Setup Guide](dns-setup.md) for your specific operating system (macOS, Linux, or Windows).


## How do I use HTTPS/SSL for my local containers?

HTTPS (port 443) is enabled by default, however Apache is using a self-signed certficate which your browser may reject. You might need to enable a feature flag:

- `edge://flags` or `chrome://flags` or `brave://flags`...
- Enable: `Allow invalid certificates for resources loaded from localhost.`


## Using custom hostnames for local sites

You can set up your Docker Dev environment to handle requests for the real/prod domains. This can be very useful for sites that use OAuth connections, like Google and [Xero](https://www.xero.com/).

Obviously this is only useful for testing OAuth on your local device. It is not suitable for receiving webhooks or sharing the project with others.

1. Browse the `apache/sites/test/` or `apache/sites/pub.test/` folders and choose a config that matches your needs the best (eg. PHP version, "public" folder)
2. Copy that config file and save it to `apache/sites/acme-corp.conf`.
    - NOTE: The folder location and `.conf` file extension is important, but the name itself can be whatever you want.
4. Edit your new config:
    1. Edit `ServerName` and type in the actual hostname you want to use. Eg. `ServerName acme-corp.com`
    2. Delete the `ServerAlias` lines
    3. Edit the `VirtualDocumentRoot` lines and swap `%1` for your project's folder name (eg. `acme-corp`). You should end up with a fully formed absolute folder path like `VirtualDocumentRoot /var/www/html/acme-corp/public`
6. Restart Apache: `docker compose restart apache` (run this while inside the docker-dev project folder)
7. Edit your hosts file and point your domain to 127.0.0.1

_Note that apache will load the conf files in alphabetical order. Because our localhost.conf has a "catch all", any of our custom conf files, must be named alphabetically before localhost.conf_
