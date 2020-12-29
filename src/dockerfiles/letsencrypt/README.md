# Using Lets Encrypt

```bash
docker build -t lets-encrypt-apache .
mkdir -p /mnt/tfo-volume-01/tfo-docker-compose/src/dockerfiles/letsencrypt/etc

export SERVER_NAME=xxx
docker-compose up -d

sudo docker run -it --rm \
-v /mnt/tfo-volume-01/tfo-docker-compose/src/dockerfiles/letsencrypt/etc:/etc/letsencrypt \
-v /docker-volumes/var/lib/letsencrypt:/var/lib/letsencrypt \
-v $PWD/html:/data/letsencrypt \
-v /docker-volumes/var/log/letsencrypt:/var/log/letsencrypt \
certbot/certbot \
certonly --webroot \
--email mbond@morgantown.ninja --agree-tos --no-eff-email \
--webroot-path=/data/letsencrypt \
-d $SERVER_NAME -d www.${SERVER_NAME}
```
