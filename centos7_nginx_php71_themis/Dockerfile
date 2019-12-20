FROM centos:7.5.1804 AS build-env
#MAINTAINER taobig

ENV NGINX_VERSION 1.14.2
ENV PHP_VERSION 7.1.27
ENV COMPOSER_VERSION 1.9.0

#if not set WORKDIR, each RUN & CMD & ADD & COPY ... need to run `cd /usr/local/src`
WORKDIR /usr/local/src

#Add user  && download php and nginx source code
#    groupadd -r www && \
#    useradd -M -s /sbin/nologin -r -g www www && /sbin/usermod -u 1000 www && \
# -M, --no-create-home
# -m, --create-home   Create the user's home directory if it does not exist.
# composer install需要
#   Cannot create cache directory /home/www/.composer/cache/repo/https---packagist.org/, or directory is not writable. Proceeding without cache
#   Cannot create cache directory /home/www/.composer/cache/files/, or directory is not writable. Proceeding without cache
# for php pecl install *** autoconf
RUN yum install -y epel-release
RUN yum install -y \
    gcc gcc-c++ make wget \
    zlib-devel openssl-devel pcre-devel libxml2-devel libcurl-devel gd-devel libpng-devel libjpeg-devel freetype-devel \
    libzip-devel \
    re2c \
    autoconf
RUN useradd -m -s /sbin/nologin www
RUN wget -c -O nginx.tar.gz http://nginx.org/download/nginx-$NGINX_VERSION.tar.gz && \
 tar -zxf nginx.tar.gz && rm -f nginx.tar.gz && \
     cd nginx-$NGINX_VERSION && \
    ./configure --prefix=/usr/local/nginx \
    --user=www --group=www \
    --error-log-path=/var/log/nginx/error.log \
    --http-log-path=/var/log/nginx/access.log \
    --pid-path=/var/run/nginx.pid \
    --with-pcre \
    --without-mail_pop3_module \
    --without-mail_imap_module \
    --without-mail_smtp_module \
    --with-http_v2_module \
    --with-http_ssl_module \
    --with-http_gzip_static_module \
    --with-http_stub_status_module && \
    make -j4 > /dev/null && make install
RUN wget -c -O php.tar.gz http://php.net/distributions/php-${PHP_VERSION}.tar.gz
#ADD cmake-3.12.4.tar.gz .
#RUN cd cmake-3.12.4 &&  ./bootstrap && make && make install
#RUN  whereis cmake
#RUN  cmake -version
#
#ADD libzip-1.5.1.tar.gz .
#RUN cd libzip-1.5.1 && mkdir build && cd build && cmake .. && make && make install
#RUN whereis libzip

RUN whereis bison
ADD bison-3.2.1.tar.gz .
RUN cd bison-3.2.1 && ./configure && make && make install
RUN whereis bison
RUN bison -V

RUN tar zxf php.tar.gz
RUN cd php-${PHP_VERSION} && \
    ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-config-file-scan-dir=/usr/local/php/etc/php.d \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-mysqli \
    --with-pdo-mysql \
    --with-openssl \
    --with-gd \
    --with-iconv \
    --with-zlib \
    --with-gettext \
    --with-curl \
    --with-png-dir \
    --with-jpeg-dir \
    --with-freetype-dir \
    --enable-fpm \
    --enable-xml \
    --enable-inline-optimization \
    --enable-mbregex \
    --enable-mbstring \
    --enable-mysqlnd \
    --enable-sockets \
    --enable-zip \
    --enable-soap \
    --enable-bcmath \
    --enable-exif \
    --enable-pcntl \
    --disable-cgi \
    --disable-phpdbg

RUN cd php-${PHP_VERSION} && make -j4 && make install && cd .. && \
    cp ./php-${PHP_VERSION}/php.ini-production /usr/local/php/etc/php.ini && \
    mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
    mv /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf  && \
    strip /usr/local/php/bin/php && \
    strip /usr/local/php/sbin/php-fpm && \
    strip /usr/local/nginx/sbin/nginx
#    --with-xmlrpc \  This extension is EXPERIMENTAL.
#    --with-mhash \
#    --disable-ctype \
#    --enable-shmop \
#    --enable-sysvsem \
#    --enable-ftp \
#   --without-pear    will remove pecl

RUN sed -i 's/^;date\.timezone[ ]*=[ ]*/date\.timezone = America\/Los_Angeles/' /usr/local/php/etc/php.ini  && \
    sed -i 's/^session\.use_strict_mode = 0/session\.use_strict_mode = 1/' /usr/local/php/etc/php.ini  && \
    sed -i 's/^session\.cookie_httponly =$/session\.cookie_httponly = 1/' /usr/local/php/etc/php.ini && \
    sed -i 's/^memory_limit = 128M/memory_limit = 256M/' /usr/local/php/etc/php.ini && \
    sed -i 's/^expose_php = On/expose_php = Off/' /usr/local/php/etc/php.ini && \
    sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 100M/' /usr/local/php/etc/php.ini && \
    sed -i 's/^pm.max_children = 5/pm.max_children = 20/' /usr/local/php/etc/php-fpm.d/www.conf  && \
    sed -i 's/^pm.min_spare_servers = 1/pm.min_spare_servers = 3/' /usr/local/php/etc/php-fpm.d/www.conf  && \
    sed -i 's/^pm.max_spare_servers = 3/pm.max_spare_servers = 7/' /usr/local/php/etc/php-fpm.d/www.conf  && \
    sed -i 's/^pm.start_servers = 2/pm.start_servers = 5/' /usr/local/php/etc/php-fpm.d/www.conf

# ; Default Value: min_spare_servers + (max_spare_servers - min_spare_servers) / 2

# use default 127.0.0.1:9000
#    sed -i 's/^listen = 127\.0\.0\.1:9000/listen = \/var\/run\/php-fpm\.sock/' /usr/local/php/etc/php-fpm.d/www.conf  && \
#    sed -i 's/^;listen.owner = www/listen.owner = www/' /usr/local/php/etc/php-fpm.d/www.conf  && \
#    sed -i 's/^;listen.group = www/listen.group = www/' /usr/local/php/etc/php-fpm.d/www.conf  && \
#    sed -i 's/^;listen.mode = 0660/listen.mode = 0660/' /usr/local/php/etc/php-fpm.d/www.conf
#    sed -i 's/^;cgi\.fix_pathinfo[ ]*=[ ]*1/cgi\.fix_pathinfo=0/' /usr/local/php/etc/php.ini
#    sed -i 's/^;security\.limit_extensions .../default setting is safe/' /usr/local/php/etc/php-fpm.d/www.conf  && \

RUN wget -c -O composer https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar

#RUN /usr/local/php/bin/pecl install igbinary && echo "extension=igbinary.so" >> /usr/local/php/etc/php.ini && \
#    echo '' | /usr/local/php/bin/pecl install redis && \
#    echo "extension=redis.so" >> /usr/local/php/etc/php.ini && \
#    rm -rf /usr/local/php/include

RUN ln  -s  /usr/local/php/bin/php    /usr/local/bin/php && \
    ln  -s  /usr/local/php/bin/phpize    /usr/local/bin/phpize && \
    ln  -s  /usr/local/php/bin/pecl    /usr/local/bin/pecl && \
    ln  -s  /usr/local/php/bin/php-config    /usr/local/bin/php-config && \
    ln  -s  /usr/local/nginx/sbin/nginx    /usr/local/sbin/nginx

ADD igbinary-3.0.1.tar.gz .
RUN cd igbinary-3.0.1 && phpize &&  ./configure && make && make install && echo "extension=igbinary.so" >> /usr/local/php/etc/php.ini
RUN php --ri igbinary

ADD redis-4.3.0.tgz .
RUN cd redis-4.3.0 && phpize &&  ./configure --enable-redis-igbinary && make && make install && echo "extension=redis.so" >> /usr/local/php/etc/php.ini
RUN php --ri redis

RUN yum install -y git
# https://blog.csdn.net/qq_28602957/article/details/72697901
RUN git clone https://github.com/longxinH/xhprof
RUN cd xhprof/extension && phpize && ./configure && make && make install
RUN echo "extension=xhprof.so" >> /usr/local/php/etc/php.ini && echo 'xhprof.output_dir = "/var/tmp/xhprof"' >> /usr/local/php/etc/php.ini
#RUN mkdir -p /var/tmp/xhprof && chown -R www:www /var/tmp/xhprof

RUN  pecl install grpc-1.22.0 protobuf-3.8.0
RUN echo "extension=grpc.so" >> /usr/local/php/etc/php.ini
RUN echo "extension=protobuf.so" >> /usr/local/php/etc/php.ini

## xdebug
RUN pecl install xdebug
#RUN echo "zend_extension=/usr/local/php/modules/xdebug.so" >> /usr/local/php/etc/php.ini
RUN echo "zend_extension=xdebug.so" >> /usr/local/php/etc/php.ini


FROM centos:7.5.1804
COPY --from=build-env /usr/local/nginx /usr/local/nginx
COPY --from=build-env /usr/local/php /usr/local/php
COPY --from=build-env /usr/local/src/composer /usr/local/bin/composer

COPY --from=build-env \
    /lib64/libcrypt.so.1 \
    /lib64/libz.so.1 \
    /lib64/libresolv.so.2 \
    /lib64/librt.so.1   \
    /lib64/libpng15.so.15   \
    /lib64/libjpeg.so.62   \
    /lib64/libcurl.so.4   \
    /lib64/libm.so.6   \
    /lib64/libdl.so.2   \
    /lib64/libnsl.so.1   \
    /lib64/libxml2.so.2  \
    /lib64/libssl.so.10   \
    /lib64/libcrypto.so.10   \
    /lib64/libfreetype.so.6  \
    /lib64/libc.so.6   \
    /lib64/libfreebl3.so  \
    /lib64/libpthread.so.0  \
    /lib64/libidn.so.11   \
    /lib64/libssh2.so.1  \
    /lib64/libssl3.so  \
    /lib64/libsmime3.so \
    /lib64/libnss3.so  \
    /lib64/libnssutil3.so  \
    /lib64/libplds4.so  \
    /lib64/libplc4.so  \
    /lib64/libnspr4.so  \
    /lib64/libgssapi_krb5.so.2  \
    /lib64/libkrb5.so.3  \
    /lib64/libk5crypto.so.3  \
    /lib64/libcom_err.so.2  \
    /lib64/liblber-2.4.so.2  \
    /lib64/libldap-2.4.so.2  \
    /lib64/ld-linux-x86-64.so.2  \
    /lib64/liblzma.so.5  \
    /lib64/libkrb5support.so.0  \
    /lib64/libkeyutils.so.1  \
    /lib64/libsasl2.so.3  \
    /lib64/libselinux.so.1 \
    /lib64/libpcre.so.1  \
    \
    /lib64/

RUN useradd -m -s /sbin/nologin www && \
    mkdir /var/log/nginx && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /app/web && chown -R www:www /app && \
    ln  -s  /usr/local/php/bin/php    /usr/local/bin/php && \
    ln  -s  /usr/local/php/bin/phpize    /usr/local/bin/phpize && \
    ln  -s  /usr/local/php/bin/pecl    /usr/local/bin/pecl && \
    ln  -s  /usr/local/php/bin/php-config    /usr/local/bin/php-config && \
    ln  -s  /usr/local/nginx/sbin/nginx    /usr/local/sbin/nginx && \
    mkdir -p /var/tmp/xhprof && chown -R www:www /var/tmp/xhprof

#overwrite nginx.conf
ADD conf/nginx.conf /usr/local/nginx/conf/nginx.conf
ADD conf/default_server.conf /etc/nginx/conf.d/default_server.conf

ADD start.sh /start.sh
RUN chmod +x /usr/local/bin/composer && \
    chmod 755 /start.sh && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime

WORKDIR /app
#VOLUME ["/usr/local/nginx/html", "/usr/local/nginx/conf/ssl", "/usr/local/nginx/conf/vhost", "/usr/local/php/etc/php.d"]
VOLUME ["/app"]

#Set port
EXPOSE 80 443

#Start it
ENTRYPOINT ["/start.sh"]

#Start web server
#CMD ["/bin/bash", "/start.sh"]
