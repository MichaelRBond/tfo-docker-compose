# tfo-docker-compose

docker build -f httpd.dockerfile -t mrbond/tfo-httpd:0.x .
docker login -u xxxx -p xxxx
docker push mrbond/tfo-httpd:0.x
