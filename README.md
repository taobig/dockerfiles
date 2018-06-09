# nginx-php7-fpm

## tags
1. **latest** , **7.2**  `CentOS 7.5.1804 + nginx 1.14 + PHP 7.2-FPM`  
1. **7.1**  `CentOS 7.5.1804 + nginx 1.14 + PHP 7.1-FPM`  
1. **7.0**  `CentOS 7.4.1708 + nginx 1.12 + PHP 7.0.30-FPM`  **no longer update**   

## usage
docker run --name ${container_name} -p ${expose_port}:80  -v ${custom_nginx_conf_dir}:/etc/nginx/conf.d -v ${code_dir}:/app  -d  taobig/nginx-php7-fpm:latest  
`/app/web` is default document root

---
Image's default timezone is **Asia/Shanghai**    
nginx log is in /var/log/nginx  
php.ini come from  php.ini-production  
php.ini settings:
1. date.timezone = Asia/Shanghai
1. session.use_strict_mode = 1
1. session.cookie_httponly = 1
1. memory_limit = 64M
1. expose_php = Off

## build-in application
/usr/local/bin/composer
