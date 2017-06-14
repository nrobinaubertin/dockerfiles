FROM node:alpine

ENV REDIS_HOST=127.0.0.1
ENV UID=791 GID=791

COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add -U --no-cache --virtual .build-deps zip unzip ca-certificates openssl \
    && apk add -U --no-cache su-exec busybox \
    && mkdir /hastebin \
    && cd /hastebin \
    && wget https://github.com/seejohnrun/haste-server/archive/master.zip \
    && unzip master.zip \
    && cd haste-server-master \
    && npm install \
    && npm install redis \
    && chmod u+x -R /usr/local/bin \
    && chown $UID:$GID -R /hastebin \
    && apk del .build-deps

WORKDIR /hastebin/haste-server-master

CMD ["run.sh"]

EXPOSE 7777
