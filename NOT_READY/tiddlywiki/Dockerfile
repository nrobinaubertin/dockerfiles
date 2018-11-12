FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG TIDDLYWIKI_VERSION=v5.1.17
ENV UID=791 GID=791
ENV USER="" PASSWORD=""
EXPOSE 8080

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

WORKDIR /tiddlywiki

RUN set -xe \
    && apk add --no-cache nodejs \
    && apk add --no-cache --virtual .build-deps ca-certificates wget \
    && wget -qO- https://github.com/Jermolene/TiddlyWiki5/archive/${TIDDLYWIKI_VERSION}.tar.gz | tar xz --strip 1 \
    && apk del .build-deps \
    && chmod -R +x /usr/local/bin /etc/s6.d

VOLUME ["/data"]
CMD ["run.sh"]
