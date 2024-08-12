#!/usr/bin/env bash

docker login

docker build --pull -t taobig/nginx-php82 .

docker push taobig/nginx-php82
