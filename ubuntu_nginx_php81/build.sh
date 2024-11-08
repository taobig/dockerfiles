#!/usr/bin/env bash

docker login || exit 1;

docker build --pull -t taobig/nginx-php81 . || exit 1;

docker push taobig/nginx-php81 || exit 1;
