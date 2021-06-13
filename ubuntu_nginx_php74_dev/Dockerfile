FROM taobig/nginx-php74:latest

#https://getcomposer.org/
ENV COMPOSER_VERSION 1.10.22

WORKDIR /app

RUN apt-get update && apt-get install -y iputils-ping vim zip git mysql-client wget && apt-get clean && rm -rf /var/lib/apt/lists/*

RUN cd /usr/local/src && \
    wget -c -O composer.phar https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar && \
    cp -rf composer.phar /usr/local/bin/composer && \
    chmod +x /usr/local/bin/composer

VOLUME ["/app"]

#Set port
EXPOSE 80 443

#Start it
ENTRYPOINT ["/start.sh"]
