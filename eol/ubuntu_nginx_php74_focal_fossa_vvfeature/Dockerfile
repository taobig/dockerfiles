FROM ubuntu:20.04 AS build-env

#http://nginx.org/en/download.html
ENV NGINX_VERSION 1.18.0
#https://www.php.net/
ENV PHP_VERSION 7.4.10

#if not set WORKDIR, each RUN & CMD & ADD & COPY ... need to run `cd /usr/local/src`
WORKDIR /usr/local/src

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get install -y wget
RUN apt-get install -y build-essential autoconf make automake bison re2c libxml2-dev libssl-dev libfreetype6-dev libcurl4-gnutls-dev libjpeg-dev libpng-dev libreadline-dev  pkg-config libzip-dev
RUN apt-get install -y libsqlite3-dev libonig-dev
# 20.04 add: libpcre3-dev (for nginx)
RUN apt-get install -y libpcre3-dev

#Add user  && download php and nginx source code
#    groupadd -r www && \
#    useradd -M -s /sbin/nologin -r -g www www && /sbin/usermod -u 1000 www && \
# -M, --no-create-home
# -m, --create-home   Create the user's home directory if it does not exist.
# composer install需要
#   Cannot create cache directory /home/www/.composer/cache/repo/https---packagist.org/, or directory is not writable. Proceeding without cache
#   Cannot create cache directory /home/www/.composer/cache/files/, or directory is not writable. Proceeding without cache
# for php pecl install *** autoconf
RUN useradd -m -s /sbin/nologin www
RUN wget -c -O nginx.tar.gz http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz
RUN tar -zxf nginx.tar.gz && rm -f nginx.tar.gz && \
     cd nginx-${NGINX_VERSION} && \
    ./configure --prefix=/usr/local/nginx \
    --user=www --group=www \
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
RUN tar zxf php.tar.gz && rm -f php.tar.gz && \
     cd php-${PHP_VERSION} && \
    ./configure --prefix=/usr/local/php \
    --with-config-file-path=/usr/local/php/etc \
    --with-config-file-scan-dir=/usr/local/php/etc/php.d \
    --with-fpm-user=www \
    --with-fpm-group=www \
    --with-mysqli \
    --with-pdo-mysql \
    --with-openssl \
    --enable-gd \
    --with-iconv \
    --with-zlib \
    --with-gettext \
    --with-curl \
    --with-jpeg \
    --with-freetype \
    --enable-fpm \
    --enable-xml \
    --enable-inline-optimization \
    --enable-mbregex \
    --enable-mbstring \
    --enable-mysqlnd \
    --enable-sockets \
    --with-zip \
    --enable-soap \
    --enable-bcmath \
    --enable-exif \
    --enable-pcntl \
    --disable-cgi \
    --disable-phpdbg \
    --with-pear \
    && \
    make -j4 > /dev/null && make install;
#    --with-xmlrpc \  This extension is EXPERIMENTAL.
#    --with-mhash \
#    --disable-ctype \
#    --enable-shmop \
#    --enable-sysvsem \
#    --enable-ftp \
#   --without-pear    will remove pecl

RUN cp ./php-${PHP_VERSION}/php.ini-production /usr/local/php/etc/php.ini && \
    mv /usr/local/php/etc/php-fpm.conf.default /usr/local/php/etc/php-fpm.conf && \
    mv /usr/local/php/etc/php-fpm.d/www.conf.default /usr/local/php/etc/php-fpm.d/www.conf  && \
    strip /usr/local/php/bin/php && \
    strip /usr/local/php/sbin/php-fpm && \
    strip /usr/local/nginx/sbin/nginx && \
    strip /usr/local/php/lib/php/extensions/no-debug-non-zts-20190902/opcache.a && \
    strip /usr/local/php/lib/php/extensions/no-debug-non-zts-20190902/opcache.so

RUN sed -i 's/^;date\.timezone[ ]*=[ ]*/date\.timezone = America\/Los_Angeles/' /usr/local/php/etc/php.ini  && \
    sed -i 's/^session\.use_strict_mode = 0/session\.use_strict_mode = 1/' /usr/local/php/etc/php.ini  && \
    sed -i 's/^session\.cookie_httponly =$/session\.cookie_httponly = 1/' /usr/local/php/etc/php.ini && \
    sed -i 's/^memory_limit = 128M/memory_limit = 128M/' /usr/local/php/etc/php.ini && \
    sed -i 's/^expose_php = On/expose_php = Off/' /usr/local/php/etc/php.ini && \
    sed -i 's/^upload_max_filesize = 2M/upload_max_filesize = 100M/' /usr/local/php/etc/php.ini && \
    sed -i 's/^listen = 127\.0\.0\.1:9000/listen = \/var\/run\/php-fpm\.sock/' /usr/local/php/etc/php-fpm.d/www.conf  && \
    sed -i 's/^;listen.owner = www/listen.owner = www/' /usr/local/php/etc/php-fpm.d/www.conf  && \
    sed -i 's/^;listen.group = www/listen.group = www/' /usr/local/php/etc/php-fpm.d/www.conf  && \
    sed -i 's/^;listen.mode = 0660/listen.mode = 0660/' /usr/local/php/etc/php-fpm.d/www.conf
#    sed -i 's/^;cgi\.fix_pathinfo[ ]*=[ ]*1/cgi\.fix_pathinfo=0/' /usr/local/php/etc/php.ini
#    sed -i 's/^;security\.limit_extensions .../default setting is safe/' /usr/local/php/etc/php-fpm.d/www.conf  && \

ADD redis-4.3.0.tgz .
RUN cd redis-4.3.0 && /usr/local/php/bin/phpize &&  ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install && echo "extension=redis.so" >> /usr/local/php/etc/php.ini
RUN /usr/local/php/bin/php --ri redis

RUN apt-get install -y git

## https://blog.csdn.net/qq_28602957/article/details/72697901
#RUN git clone https://github.com/longxinH/xhprof
#RUN cd xhprof/extension && /usr/local/php/bin/phpize && ./configure --with-php-config=/usr/local/php/bin/php-config && make && make install
#RUN echo "extension=xhprof.so" >> /usr/local/php/etc/php.ini && echo 'xhprof.output_dir = "/var/tmp/xhprof"' >> /usr/local/php/etc/php.ini
#RUN /usr/local/php/bin/php --ri xhprof
##RUN mkdir -p /var/tmp/xhprof && chown -R www:www /var/tmp/xhprof

# grpc-1.31.0 protobuf-3.11.2 ok(2020-09-11)
# latest version: grpc-1.31.1 protobuf-3.13.0 ok(2020-09-11)??
#RUN /usr/local/php/bin/pecl install grpc-1.22.0 protobuf-3.8.0 与PHP7.4不兼容
RUN /usr/local/php/bin/pecl install grpc-1.31.1 protobuf-3.13.0
RUN echo "extension=grpc.so" >> /usr/local/php/etc/php.ini
RUN echo "extension=protobuf.so" >> /usr/local/php/etc/php.ini
RUN /usr/local/php/bin/php --ri grpc
RUN /usr/local/php/bin/php --ri protobuf

RUN /usr/local/php/bin/pecl install xdebug
#RUN echo "zend_extension=/usr/local/php/modules/xdebug.so" >> /usr/local/php/etc/php.ini
RUN echo "zend_extension=xdebug.so" >> /usr/local/php/etc/php.ini
RUN /usr/local/php/bin/php --ri xdebug

RUN /usr/local/php/bin/pecl install phalcon-4.0.6
#RUN ln  -s  /usr/local/php/bin/php    /usr/local/bin/php && \
#    ln  -s  /usr/local/php/bin/phpize    /usr/local/bin/phpize && \
#    ln  -s  /usr/local/php/bin/pecl    /usr/local/bin/pecl && \
#    ln  -s  /usr/local/php/bin/php-config    /usr/local/bin/php-config && \
#    ln  -s  /usr/local/nginx/sbin/nginx    /usr/local/sbin/nginx
## compile version 3.4.x 依赖环境变量
#RUN git clone --depth=1 -b 4.x git://github.com/phalcon/cphalcon.git
#RUN cd cphalcon/build && ./install
RUN echo "extension=phalcon.so" >> /usr/local/php/etc/php.ini
RUN echo "extension=psr.so" >> /usr/local/php/etc/php.ini
RUN /usr/local/php/bin/php --ri phalcon


RUN apt install -y build-essential autoconf libtool pkg-config  cmake
# clang-5.0 libc++-dev

RUN apt install -y golang
RUN apt install -y curl git
RUN apt install -y automake libtool build-essential
RUN git clone --depth=1 -b v1.31.1 https://github.com/grpc/grpc
RUN cd grpc && git submodule update --init

#`bazel` or `cmake`.
### Building with bazel (recommended)
#
#Bazel is the primary build system for gRPC C++ and if you're comfortable with using bazel, we can certainly recommend it.
#Using bazel will give you the best developer experience as well as faster and cleaner builds.
#
#You'll need `bazel` version `1.0.0` or higher to build gRPC.
#See [Installing Bazel](https://docs.bazel.build/versions/master/install.html) for instructions how to install bazel on your system.
#We support building with `bazel` on Linux, MacOS and Windows.
#
#From the grpc repository root
## Build gRPC C++
#$ bazel build :all

# `cmake`
RUN  cd grpc && mkdir -p cmake/build && cd cmake/build && cmake ../.. &&  make
#安装用于生成PHP代码的protoc plugin
RUN cd grpc/cmake/build && make grpc_php_plugin
#compile protoc -> protoc --version v3.12.2 用于生成php sdk
RUN cd grpc/third_party/protobuf  && ./autogen.sh && ./configure && make && make install
#RUN file /usr/local/lib/libprotoc.so.23
#/usr/local/lib/libprotoc.so.23: symbolic link to libprotoc.so.23.0.2
#RUN file /usr/local/lib/libprotoc.so.23.0.2
RUN cp -t  /usr/lib/  /usr/local/lib/libprotoc.so.23 /usr/local/lib/libprotobuf.so.23


FROM ubuntu:20.04
COPY --from=build-env /usr/local/nginx /usr/local/nginx
COPY --from=build-env /usr/local/php /usr/local/php

COPY --from=build-env /usr/local/bin/protoc  /usr/local/bin/protoc
COPY --from=build-env /usr/local/src/grpc/cmake/build/grpc_php_plugin  /usr/local/bin/grpc_php_plugin
COPY --from=build-env /usr/local/lib/libprotoc.so.23  /usr/local/lib/libprotoc.so.23
COPY --from=build-env /usr/local/lib/libprotobuf.so.23  /usr/local/lib/libprotobuf.so.23

COPY --from=build-env   \
    /lib/x86_64-linux-gnu/liblzma.so.5 \
    /lib/x86_64-linux-gnu/libcom_err.so.2 \
    /lib/x86_64-linux-gnu/libc.so.6 \
    /lib/x86_64-linux-gnu/libcrypt.so.1 \
    /lib/x86_64-linux-gnu/libdl.so.2 \
    /lib/x86_64-linux-gnu/libgcc_s.so.1 \
    /lib/x86_64-linux-gnu/libkeyutils.so.1 \
    /lib/x86_64-linux-gnu/libm.so.6 \
    /lib/x86_64-linux-gnu/libpthread.so.0 \
    /lib/x86_64-linux-gnu/libresolv.so.2 \
    /lib/x86_64-linux-gnu/libz.so.1 \
    /lib/x86_64-linux-gnu/libhogweed.so.5 \
    lib/x86_64-linux-gnu/libnettle.so.7 \
    /lib/x86_64-linux-gnu/libicuuc.so.66 \
    /lib/x86_64-linux-gnu/libicudata.so.66   \
    /lib/x86_64-linux-gnu/libffi.so.7   \
    /lib/x86_64-linux-gnu/libonig.so.5 \
    /lib/x86_64-linux-gnu/libzip.so.5 \
    /lib/x86_64-linux-gnu/libhx509.so.5  \
    /lib/x86_64-linux-gnu/libsqlite3.so.0  \
    /lib/x86_64-linux-gnu/libjpeg.so.8   \
    /lib/x86_64-linux-gnu/libpng16.so.16   \
    /lib/x86_64-linux-gnu/libcurl-gnutls.so.4   \
    /lib/x86_64-linux-gnu/libssl.so.1.1   \
    /lib/x86_64-linux-gnu/libasn1.so.8   \
    /lib/x86_64-linux-gnu/libcrypto.so.1.1   \
    /lib/x86_64-linux-gnu/libgnutls.so.30   \
    /lib/x86_64-linux-gnu/libhcrypto.so.4   \
    /lib/x86_64-linux-gnu/libheimbase.so.1   \
    /lib/x86_64-linux-gnu/libidn2.so.0   \
    /lib/x86_64-linux-gnu/libk5crypto.so.3   \
    /lib/x86_64-linux-gnu/liblber-2.4.so.2   \
    /lib/x86_64-linux-gnu/libroken.so.18   \
    /lib/x86_64-linux-gnu/libstdc++.so.6   \
    /lib/x86_64-linux-gnu/libwind.so.0   \
    /lib/x86_64-linux-gnu/libxml2.so.2   \
    /lib/x86_64-linux-gnu/libfreetype.so.6  \
    /lib/x86_64-linux-gnu/libnghttp2.so.14  \
    /lib/x86_64-linux-gnu/librtmp.so.1   \
    /lib/x86_64-linux-gnu/libpsl.so.5   \
    /lib/x86_64-linux-gnu/libgssapi_krb5.so.2   \
    /lib/x86_64-linux-gnu/libldap_r-2.4.so.2   \
    /lib/x86_64-linux-gnu/libunistring.so.2   \
    /lib/x86_64-linux-gnu/libgmp.so.10   \
    /lib/x86_64-linux-gnu/libp11-kit.so.0   \
    /lib/x86_64-linux-gnu/libtasn1.so.6   \
    /lib/x86_64-linux-gnu/libkrb5.so.26   \
    /lib/x86_64-linux-gnu/libkrb5support.so.0   \
    /lib/x86_64-linux-gnu/libkrb5.so.3   \
    /lib/x86_64-linux-gnu/libsasl2.so.2   \
    /lib/x86_64-linux-gnu/libgssapi.so.3   \
    /lib/x86_64-linux-gnu/libheimntlm.so.0   \
    /lib/x86_64-linux-gnu/libssh.so.4 \
    /lib/x86_64-linux-gnu/libbrotlidec.so.1 \
    /lib/x86_64-linux-gnu/libbrotlicommon.so.1 \
    \
    /lib/x86_64-linux-gnu/

#overwrite nginx.conf
ADD conf/nginx.conf /usr/local/nginx/conf/nginx.conf
ADD conf/default_server.conf /etc/nginx/conf.d/default_server.conf
ADD start.sh /start.sh

# /var/lib/apt/lists is huge
RUN useradd -m -s /sbin/nologin www && \
    mkdir /var/log/nginx && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /app/web && chown -R www:www /app && \
    ln  -s  /usr/local/php/bin/php    /usr/local/bin/php && \
    ln  -s  /usr/local/php/bin/phpize    /usr/local/bin/phpize && \
    ln  -s  /usr/local/php/bin/pecl    /usr/local/bin/pecl && \
    ln  -s  /usr/local/php/bin/php-config    /usr/local/bin/php-config && \
    ln  -s  /usr/local/nginx/sbin/nginx    /usr/local/sbin/nginx && \
    chmod 755 /start.sh && \
    ln -sf /usr/share/zoneinfo/Asia/Shanghai  /etc/localtime  && \
    apt-get update && apt-get install -y git tzdata ca-certificates iputils-ping vim && apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
#VOLUME ["/usr/local/nginx/html", "/usr/local/nginx/conf/ssl", "/usr/local/nginx/conf/vhost", "/usr/local/php/etc/php.d"]
VOLUME ["/app"]

#Set port
EXPOSE 80 443

#Start it
ENTRYPOINT ["/start.sh"]

#Start web server
#CMD ["/bin/bash", "/start.sh"]
