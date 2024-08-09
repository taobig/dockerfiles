#!/usr/bin/env bash

docker build --pull -t taobig/nginx-php81:dy .

docker push taobig/nginx-php81:dy
