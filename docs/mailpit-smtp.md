# Mailpit

Mailpit acts as an SMTP server and also provides a web interface to view all captured emails.

We use the official [Mailpit](https://hub.docker.com/r/axllent/mailpit) image.


## General Use

When PHP sends emails using sendmail or SMTP, it's automatically "caught" by [Mailpit](https://github.com/axllent/mailpit). This enables you to review the emails without delivering them to real email addresses.

You can view anything which has been caught at [http://localhost:8025/](http://localhost:8025/).


## Connecting

You can configure any SMTP client (such as PHP applications) to use Mailpit.

| Parameter | Value |
|-------------|---|
| Host | `mailpit` (from a container)<br>`localhost` (from your computer) |
| Port | `1025` |
