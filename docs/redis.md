# Redis

We use the official [Redis](https://hub.docker.com/_/redis) Docker image.

> In March 2024, Redis announced that they will be [changing their BSD license](https://redis.com/blog/redis-adopts-dual-source-available-licensing/) to ones that are not open-source. This change will take effect from Redis v7.4 onwards. We have locked our Docker image to Redis v7.2.x (which uses the BSD open source license), and we may consider using a Redis alternative in the future.


## Connecting

| Parameter | Value |
|-------------|---|
| Host | `redis` (from a container)<br>`localhost` (from your computer) |
| Port | `6379` |
| Password | `` |
