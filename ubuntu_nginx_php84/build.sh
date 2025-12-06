#!/usr/bin/env bash

docker login

#docker build --pull -t taobig/nginx-php84 . || exit 1;
#docker push taobig/nginx-php84 || exit 1;

docker build --pull -t taobig/nginx-php84 --push .
