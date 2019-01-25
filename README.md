# 

## Docker images  
| Source Code | Dockerfile location | Docker image | Desc |
| ------ | ------ | ------ | ------ |
| Tag: v1.3 | centos7_nginx_php70 | **taobig/nginx-php7-fpm:7.0** | `CentOS 7.4.1708 + nginx 1.14.2 + PHP 7.0.33-FPM` composer |
| Branch: master | centos7_nginx_php71 | **taobig/nginx-php7-fpm:7.1** | `CentOS 7.5.1804 + nginx 1.14.2 + PHP 7.1-FPM` composer |
| Branch: master | ubuntu_nginx_php72 | **taobig/nginx-php72** | `Ubuntu:18.04 + nginx 1.14.2 + PHP 7.2-FPM` composer + crontab + vim |
| Branch: master | ubuntu_nginx_php73 | **taobig/nginx-php73** | `Ubuntu:18.04 + nginx 1.14.2 + PHP 7.3-FPM` composer + crontab + vim |

## usage
> docker run --name ${container_name} -p ${expose_port}:80  -v ${custom_nginx_conf_dir}:/etc/nginx/conf.d -v ${code_dir}:/app -d taobig/nginx-php73  
> **`/app/web` is default document root**

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


# build manually
cd {dir}
docker build -t taobig/php7x .
