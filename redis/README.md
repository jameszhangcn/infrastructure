#redis


Redis can be accessed via port 6379 on the following DNS name from within your cluster:
my-redis-redis.default.svc.cluster.local
To get your password run:

    REDIS_PASSWORD=$(kubectl get secret --namespace default my-redis-redis -o jsonpath="{.data.redis-password}" | base64 --decode)

To connect to your Redis server:

1. Run a Redis pod that you can use as a client:

   kubectl run --namespace default my-redis-redis-client --rm --tty -i \
    --env REDIS_PASSWORD=$REDIS_PASSWORD \
   --image bitnami/redis:4.0.8-r2 -- bash

2. Connect using the Redis CLI:

  redis-cli -h my-redis-redis -a $REDIS_PASSWORD


有时候会有中文乱码。

要在 redis-cli 后面加上 --raw

redis-cli --raw