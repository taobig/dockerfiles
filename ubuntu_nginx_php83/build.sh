#!/usr/bin/env bash

docker login

docker build --pull -t taobig/nginx-php83 .

docker push taobig/nginx-php83
