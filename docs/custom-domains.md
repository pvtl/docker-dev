# Custom Domain Names

You can set up your Docker Dev environment to handle requests for the real/prod domains. This can be very useful for sites that use OAuth connections, like Google and [Xero](https://www.xero.com/).

Obviously this is only useful for testing OAuth on your local device. It's not suitable for receiving webhooks or sharing the project with others.

1. Browse the `apache/sites/localhost/` or `apache/sites/pub.localhost/` folders and choose a config that matches your needs the best (eg. PHP version, "public" folder)
2. Copy that config file and save it to `apache/sites/acme-corp.conf`.
    - NOTE: The folder location and `.conf` file extension is important, but the name itself can be whatever you want.
4. Edit your new config:
    1. Edit `ServerName` and type in the actual hostname you want to use. Eg. `ServerName acme-corp.com`
    2. Delete the `ServerAlias` lines
    3. Edit the `VirtualDocumentRoot` lines and swap `%1` for your project's folder name (eg. `acme-corp`). You should end up with a fully formed absolute folder path like `VirtualDocumentRoot /var/www/html/acme-corp/public`
6. Reload the Apache container: `docker-compose restart apache` (run this while inside the docker-dev project folder)
7. Edit your hosts file and point your domain to 127.0.0.1
