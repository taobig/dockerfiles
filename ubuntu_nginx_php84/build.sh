#!/usr/bin/env bash

docker login

#docker build --pull -t taobig/nginx-php84 . || exit 1;
#docker push taobig/nginx-php84 || exit 1;

#docker build --pull -t taobig/nginx-php84 --push .
docker buildx build --pull --platform linux/amd64,linux/arm64 -t taobig/nginx-php84 --push .
