#!/usr/bin/env bash

caddy fmt caddy/Caddyfile --overwrite
caddy fmt caddy/sites/example.com.conf --overwrite

docker build --pull -t taobig/caddy-php81 .