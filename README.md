# 

## Docker images  
| Dockerfile location                | Docker image                       | Desc                                                               |
|------------------------------------|------------------------------------|--------------------------------------------------------------------|
| eol/centos7_nginx_php70            |                                    | `CentOS:7.4.1708 + nginx 1.14.2 + PHP 7.0.33-FPM` + composer       |
| eol/centos7_nginx_php71            | **taobig/nginx-php7-fpm:7.1**      | `CentOS:7.5.1804 + nginx 1.16.1 + PHP 7.1.33-FPM` + composer       |
| eol/ubuntu_nginx_php72             | **taobig/nginx-php72**             | `Ubuntu:18.04 + nginx 1.16.1 + PHP 7.2.21-FPM` composer + crontab + vim |
| eol/ubuntu_nginx_php73             | **taobig/nginx-php73**             | `Ubuntu:18.04 + nginx 1.16.1 + PHP 7.3.28-FPM` composer + vim           |
| eol/ubuntu_nginx_php74             | **taobig/nginx-php74**             | `Ubuntu:18.04 + nginx 1.16.1 + PHP 7.4.33-FPM`                          |
| eol/ubuntu_nginx_php74_focal_fossa | **taobig/nginx-php74:focal_fossa** | `Ubuntu:20.04 + nginx 1.18.0 + PHP 7.4.33-FPM` iputils + vim            |
| eol/ubuntu_nginx_php80             | **taobig/nginx-php80**             | `Ubuntu:20.04 + nginx 1.20.2 + PHP 8.0.30-FPM`                          |
| ubuntu_nginx_php81                 | **taobig/nginx-php81**             | `Ubuntu:20.04 + nginx 1.22 + PHP 8.1-FPM`                          |
| ubuntu_nginx_php82                 | **taobig/nginx-php82**             | `Ubuntu:20.04 + nginx 1.24 + PHP 8.2-FPM`                          |
| ubuntu_nginx_php83                 | **taobig/nginx-php83**             | `Ubuntu:20.04 + nginx 1.24 + PHP 8.3-FPM`                          |

## usage
```shell
docker run --name ${container_name} -p ${expose_port}:80  -v ${custom_nginx_conf_dir}:/etc/nginx/conf.d -v ${code_dir}:/app -d taobig/nginx-php74
``` 
** default document root:`/app/web` **

---
Image's default timezone is **Asia/Shanghai**    
nginx log is in /var/log/nginx  
php.ini come from  php.ini-production  
php.ini settings:
1. date.timezone = Asia/Shanghai
2. session.use_strict_mode = 1
3. session.cookie_httponly = 1
4. memory_limit = 128M
5. expose_php = Off
6. upload_max_filesize = 100M
7. max_execution_time = 60
8. request_terminate_timeout = 120
9. ...


# build manually
```bash
cd ubuntu_nginx_php81
docker build --pull -t taobig/nginx-php81 .
docker run --rm --name php81 -d taobig/nginx-php81

cd ubuntu_nginx_php81_dev
docker build --pull -t taobig/nginx-php81:dev .
```




<style>
th:not(:last-child),
td:not(:last-child) {
  white-space: nowrap;
}
</style>

