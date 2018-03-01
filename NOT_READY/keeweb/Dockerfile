FROM alpine:3.7

ARG KEEWEB_VERSION=1.6.3
ENV UID=791 GID=791

WORKDIR /keeweb

COPY run.sh /usr/local/bin/run.sh
COPY server.sh /keeweb/server.sh

RUN set -xe \
    && apk add --no-cache -U su-exec netcat-openbsd \
    && apk add --no-cache --virtual .build-deps openssl wget unzip nodejs-npm git python2 ca-certificates \
    && wget -O keeweb.zip https://github.com/keeweb/keeweb/archive/v${KEEWEB_VERSION}.zip \
    && unzip keeweb.zip \
    && rm keeweb.zip \
    && cd keeweb-${KEEWEB_VERSION} \
    && npm install \
    && sed -iE 's/"grunt"/"grunt --skip-sign"/' package.json \
    && npm start \
    && cd .. \
    && mv keeweb-${KEEWEB_VERSION}/dist/index.html . \
    && rm -rf keeweb-${KEEWEB_VERSION} \
    && npm cache clean --force \
    && apk del .build-deps \
    && rm -rf /root \
    && chmod 770 /keeweb/server.sh \
    && chmod -R +x /usr/local/bin/run.sh

EXPOSE 8080

CMD ["run.sh"]
