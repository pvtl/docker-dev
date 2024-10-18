# Valkey

We use the official [Valkey](https://hub.docker.com/r/valkey/valkey/) Docker image. It aims to be fully compatible with Redis.

> In March 2024, Redis announced that they will be [changing their BSD license](https://redis.com/blog/redis-adopts-dual-source-available-licensing/) to ones that are not open-source. As a result, we have swapped to using the open source fork of Redis, called Valkey.


## Connecting

| Parameter | Value |
|-------------|---|
| Host | `valkey` (from a container)<br>`localhost` (from your computer) |
| Port | `6379` |
| Password | `` |

> For backwards compatibility we've added a `redis` alias. You can either hostname in your application.
