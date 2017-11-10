FROM alpine:3.6

ARG WORDPRESS=4.8.3
ENV UID=791 GID=791
EXPOSE 8080
WORKDIR /wordpress

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY run.sh /usr/local/bin/run.sh 
COPY run2.sh /usr/local/bin/run2.sh 
COPY wp-config.php /wordpress/wp-config.php
COPY nginx /etc/nginx

RUN set -xe \
    && apk add --no-cache -U s6 su-exec nginx php7-fpm ca-certificates mariadb openssl mariadb-client \
    && apk add --no-cache php7-curl php7-dom php7-ftp php7-gd php7-iconv php7-json php7-xml php7-mbstring php7-pdo_mysql php7-mysqli php7-openssl php7-tokenizer php7-zlib \
    && wget -qO- https://wordpress.org/wordpress-${WORDPRESS}.tar.gz | tar xz --strip 1 \
    && mkdir -p /php/logs /nginx/logs /nginx/tmp \
    && mv wp-content wp-content-original \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

VOLUME /wordpress/wp-content

CMD ["run.sh"]
