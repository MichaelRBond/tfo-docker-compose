FROM httpd:2.4

COPY ./httpd/httpd.conf /usr/local/apache2/conf/httpd.conf
COPY ./httpd/ssl_local.conf /usr/local/apache2/conf/ssl_local.conf
