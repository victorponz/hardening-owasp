#!/usr/bin/env bash

# run.sh

# run the container in the background
# /data is persisted using a named container

docker run \
    --detach \
    --rm \
    -p 8080:80 \
    --name="hardenowasp" \
    hardenowasp
