#!/bin/sh

set -ex
# remove the current app instance
if [ -n "$(docker ps -aq -f name=nickwebdemo)" ]; then
    docker rm -f nickwebdemo
fi

# run a new app instance
docker run -d \
    -p 8088:8088 \
    --name nickwebdemo \
    --restart=always \
    gowebdemo
