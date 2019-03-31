FROM alpine:3.9
RUN apk add --no-cache -U su-exec s6 tini
ENTRYPOINT ["/sbin/tini", "--"]

ARG KANBOARD_VERSION=v1.2.8
ENV UID=791 GID=791
EXPOSE 8080

WORKDIR /kanboard

COPY s6.d /etc/s6.d
COPY php7 /etc/php7
COPY nginx /etc/nginx
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache openssl unzip nginx bash ca-certificates curl ssmtp mailx php7 php7-phar php7-curl \
		php7-fpm php7-json php7-zlib php7-xml php7-dom php7-ctype php7-opcache php7-zip php7-iconv \
		php7-pdo php7-pdo_mysql php7-pdo_sqlite php7-pdo_pgsql php7-mbstring php7-session php7-bcmath \
		php7-gd php7-mcrypt php7-openssl php7-sockets php7-posix php7-ldap php7-simplexml \
	&& wget -qO- https://github.com/kanboard/kanboard/archive/${KANBOARD_VERSION}.tar.gz | tar xz --strip 1 \
	&& rm -rf /kanboard/docker \
    && chmod -R +x /usr/local/bin /etc/s6.d /var/lib/nginx

VOLUME ["/kanboard/data"]
CMD ["run.sh"]
