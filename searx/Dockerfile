FROM alpine:3.7

ARG SEARX_VERSION=v0.14.0
ENV BASE_URL=False IMAGE_PROXY=False
ENV UID=791 GID=791

EXPOSE 8888

COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache -U su-exec python libxml2 libxslt openssl \
    && apk add --no-cache --virtual .build-deps build-base py2-pip python2-dev libffi-dev libxslt-dev libxml2-dev openssl-dev tar ca-certificates \
    && mkdir /usr/local/searx && cd /usr/local/searx \
    && wget -qO- https://github.com/asciimoo/searx/archive/$SEARX_VERSION.tar.gz | tar xz --strip 1 \
    && pip install --no-cache -r requirements.txt \
    && sed -i "s/127.0.0.1/0.0.0.0/g" searx/settings.yml \
    && apk del .build-deps \
    && rm -f /var/cache/apk/* \
    && chmod u+x /usr/local/bin/run.sh

CMD ["run.sh"]
