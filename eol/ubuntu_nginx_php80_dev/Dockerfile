FROM taobig/nginx-php80:latest

# https://getcomposer.org/
ARG COMPOSER_VERSION=2.1.14

WORKDIR /app

RUN apt-get update && apt-get install -y iputils-ping vim zip git mysql-client wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/* && \
    cd /usr/local/src && \
    wget -c -O composer.phar https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar && \
    mv composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer
#    cp -rf composer.phar /usr/local/bin/composer && \

VOLUME ["/app"]

#Set port
EXPOSE 80 443

#Start it
ENTRYPOINT ["/start.sh"]
