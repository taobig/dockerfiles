# 

## Docker images  
| Source Code | Dockerfile location | Docker image | Desc |
| ------ | ------ | ------ | ------ |
| Tag: v1.3.3-PHP7.0 | centos7_nginx_php70 | **taobig/nginx-php7-fpm:7.0** | `CentOS 7.4.1708 + nginx 1.14.2 + PHP 7.0.33-FPM` composer |
| Branch: master | centos7_nginx_php71 | **taobig/nginx-php7-fpm:7.1** | `CentOS 7.5.1804 + nginx 1.16 + PHP 7.1-FPM` composer |
| Branch: master | ubuntu_nginx_php72 | **taobig/nginx-php72** | `Ubuntu:18.04 + nginx 1.16 + PHP 7.2-FPM` composer + crontab + vim |
| Branch: master | ubuntu_nginx_php73 | **taobig/nginx-php73** | `Ubuntu:18.04 + nginx 1.16 + PHP 7.3-FPM` composer + vim |
| Branch: master | ubuntu_nginx_php74 | **taobig/nginx-php74** | `Ubuntu:18.04 + nginx 1.16 + PHP 7.4-FPM` |
| Branch: master | ubuntu_nginx_php74_focal_fossa | **taobig/nginx-php74:focal_fossa** | `Ubuntu:20.04 + nginx 1.18 + PHP 7.4-FPM` iputils + vim |
| Branch: master | ubuntu_nginx_php80 | **taobig/nginx-php80** | `Ubuntu:20.04 + nginx 1.20 + PHP 8.0-FPM` |

## usage
> docker run --name ${container_name} -p ${expose_port}:80  -v ${custom_nginx_conf_dir}:/etc/nginx/conf.d -v ${code_dir}:/app -d taobig/nginx-php74 
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
1. upload_max_filesize = 100M


# build manually
```bash
cd {dir}
docker build -t taobig/nginx-php80 .
docker build -t taobig/nginx-php80:dev .
docker run --rm --name php80 -d taobig/nginx-php80


docker build -t php8x .
docker run --rm --name php8x -d php8x

```




