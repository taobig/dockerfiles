# nginx-php7-fpm
based on centos:7.4.1708
## tag name
1. **latest** , **7.2**  ` nginx + PHP 7.2-FPM`  
1. **7.1**  ` nginx + PHP 7.1-FPM`  
1. **7.0**  ` nginx + PHP 7.0-FPM`    

## usage
docker run --name ${container_name} -p ${expose_port}:80  -v ${custom_nginx_conf_dir}:/etc/nginx/conf.d -v ${code_dir}:/app  -d  taobig/nginx-php7-fpm:latest

---
Image's default timezone is **Asia/Shanghai**    
nginx log is in /var/log/nginx  
php.ini come from  php.ini-production  
php.ini settings:
1. cgi.fix_pathinfo=0
1. date.timezone = Asia/Shanghai
1. session.use_strict_mode = 1
1. session.cookie_httponly = 1
1. memory_limit = 64M

## build-in application
/usr/local/bin/composer
