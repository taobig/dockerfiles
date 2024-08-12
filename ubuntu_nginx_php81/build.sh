#!/usr/bin/env bash

docker login

docker build --pull -t taobig/nginx-php81 .

docker push taobig/nginx-php81
