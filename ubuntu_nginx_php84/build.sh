#!/usr/bin/env bash

docker login

#docker build --pull -t taobig/nginx-php84 . || exit 1;
#docker push taobig/nginx-php84 || exit 1;

#docker build --pull -t taobig/nginx-php84 --push .
docker buildx build --pull --platform linux/amd64,linux/arm64 -t taobig/nginx-php84 --push .

# 清 dangling 构建缓存（-f 跳过确认）；下次构建多数层仍可命中 cache
#docker buildx prune -f
# 更狠：连 internal/frontend 镜像一起清（-a），磁盘能腾更多，但下次几乎全量重编
#docker buildx prune -af
