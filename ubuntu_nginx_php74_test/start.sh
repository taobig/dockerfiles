#!/usr/bin/env bash

/usr/local/php/sbin/php-fpm
#/usr/local/nginx/sbin/nginx -c /usr/local/nginx/conf/nginx.conf
/usr/local/nginx/sbin/nginx

#tail -f /start.sh
#tail -f /usr/local/php/var/log/php-fpm.log
tail -f /var/log/nginx/error.log;
