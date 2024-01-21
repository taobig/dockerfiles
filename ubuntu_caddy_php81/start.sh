#!/usr/bin/env bash

/usr/local/php/sbin/php-fpm
#/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
#/usr/local/nginx/sbin/nginx

#/usr/local/bin/caddy
# To run Caddy, use:
# - 'caddy run' to run Caddy in the foreground (recommended).
# - 'caddy start' to start Caddy in the background; only do this
#   if you will be keeping the terminal window open until you run
#   'caddy stop' to close the server.

#/usr/local/bin/caddy start --config /etc/caddy/Caddyfile
#tail -f /var/log/caddy/system.log;
# or
#/usr/local/bin/caddy run --config caddy.json
/usr/local/bin/caddy run --config /etc/caddy/Caddyfile



