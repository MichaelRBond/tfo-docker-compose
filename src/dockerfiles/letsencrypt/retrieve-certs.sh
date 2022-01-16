#!/bin/bash

set -e

LETS_ENCRYPT_DIR=/mnt/tfo-volume-01/tfo-docker-compose/src/dockerfiles/letsencrypt

cd $LETS_ENCRYPT_DIR
docker build -t lets-encrypt-apache .
mkdir -p $LETS_ENCRYPT_DIR/etc

# "whiteeaglemartialarts.com"
DOMAINS=("morgantown.ninja" "the-forgotten.org" "baiyingpai.com" "emmasbond.me" "fairmontflyers.org" "kathnmike.us" "robertbond.me" "scottnale.com")
SUB_DOMAINS=("grapevine.the-forgotten.org" "api.grapevine.the-forgotten.org")

for DOMAIN in "${DOMAINS[@]}"; do
  export SERVER_NAME=$DOMAIN

  docker-compose up -d
  sleep 10

  sudo docker run -it --rm \
  -v $LETS_ENCRYPT_DIR/etc:/etc/letsencrypt \
  -v /docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
  -v $PWD/html:/data/letsencrypt \
  -v /docker-volumes/var/log/letsencrypt:/var/log/letsencrypt \
  certbot/certbot \
  certonly --webroot \
  --email mbond@morgantown.ninja --agree-tos --no-eff-email \
  --webroot-path=/data/letsencrypt \
  --force-renewal \
  -d $SERVER_NAME -d www.${SERVER_NAME}

  docker-compose down
  sleep 10
done

for DOMAIN in "${SUB_DOMAINS[@]}"; do
  export SERVER_NAME=$DOMAIN

  docker-compose up -d
  sleep 10

  sudo docker run -it --rm \
  -v $LETS_ENCRYPT_DIR/etc:/etc/letsencrypt \
  -v /docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
  -v $PWD/html:/data/letsencrypt \
  -v /docker-volumes/var/log/letsencrypt:/var/log/letsencrypt \
  certbot/certbot \
  certonly --webroot \
  --email mbond@morgantown.ninja --agree-tos --no-eff-email \
  --webroot-path=/data/letsencrypt \
  --force-renewal \
  -d $SERVER_NAME

  docker-compose down
  sleep 10
done
