# nginx-php73-fpm

## tags
1. **latest**  `Ubuntu:18.04 + nginx:1.14 + PHP:7.3(PHP-FPM)`  

## usage
docker run --name ${container_name} -p ${expose_port}:80  -v ${custom_nginx_conf_dir}:/etc/nginx/conf.d -v ${code_dir}:/app  -d  taobig/nginx-php73:latest  
`/app/web` is default document root

---
Image's default timezone is **Asia/Shanghai**    
nginx log is in /var/log/nginx  
php.ini come from  php.ini-production  
php.ini settings:
1. date.timezone = Asia/Shanghai
1. session.use_strict_mode = 1
1. session.cookie_httponly = 1
1. memory_limit = 128M
1. expose_php = Off

## build-in application
/usr/local/bin/composer
