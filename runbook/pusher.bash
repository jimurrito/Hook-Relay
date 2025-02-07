#!/bin/bash

if [[ -z "$(docker buildx ls | grep hook-builder)" ]]; then
    docker buildx create --name hook-builder --driver docker-container --use --bootstrap
fi

#docker buildx build --pull --push --platform linux/amd64,linux/arm64 -t jimurrito/hook-relay:$(date "+%Y%m%d") .. && \
#docker buildx build --pull --push --platform linux/amd64,linux/arm64 -t jimurrito/hook-relay:latest ..

docker buildx build --pull --push --platform linux/amd64 -t jimurrito/hook-relay:$(date "+%Y%m%d") .. && \
docker buildx build --pull --push --platform linux/amd64 -t jimurrito/hook-relay:latest ..