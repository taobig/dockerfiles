FROM taobig/nginx-php81:latest

WORKDIR /app

# `ping` from iputils-ping
# `ip` from iproute2
RUN apt-get update && apt-get install -y iputils-ping iproute2 vim zip git mysql-client wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# https://getcomposer.org/
ARG COMPOSER_VERSION=2.7.4

RUN cd /usr/local/src && \
    wget -c -O composer.phar https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar && \
    cp -rf composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer


#VOLUME ["/app"]
#
##Set port
#EXPOSE 80 443
#
##Start it
#ENTRYPOINT ["/start.sh"]
