FROM taobig/nginx-php82:latest

WORKDIR /app

RUN apt-get -y update && apt-get install -y iputils-ping vim zip git mysql-client wget && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

VOLUME ["/app"]

#Set port
EXPOSE 80 443

#Start it
ENTRYPOINT ["/start.sh"]
