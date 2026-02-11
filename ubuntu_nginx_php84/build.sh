#!/usr/bin/env bash

docker login

#docker build --pull -t taobig/nginx-php84 . || exit 1;
#docker push taobig/nginx-php84 || exit 1;

#docker build --pull -t taobig/nginx-php84 --push .
#docker buildx build --pull --platform linux/amd64,linux/arm64 -t taobig/nginx-php84 --push .
# TODO: 对于arm64平台，Dockerfile中链接库路径需要修改。
docker buildx build --pull --platform linux/amd64 -t taobig/nginx-php84 --push .
