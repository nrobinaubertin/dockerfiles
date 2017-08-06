FROM alpine:3.6

ENV BASE_URL=False IMAGE_PROXY=False
ENV UID=791 GID=791
ENV SEARX_VERSION=v0.12.0

EXPOSE 8888

COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache -U su-exec python libxml2 libxslt openssl py2-pip \
    && apk add --no-cache --virtual .build-deps build-base python-dev libffi-dev libxslt-dev libxml2-dev openssl-dev tar ca-certificates \
    && pip install --no-cache -r https://raw.githubusercontent.com/asciimoo/searx/$SEARX_VERSION/requirements.txt \
    && mkdir /usr/local/searx && cd /usr/local/searx \
    && wget -qO- https://github.com/asciimoo/searx/archive/$SEARX_VERSION.tar.gz | tar xz --strip 1 \
    && sed -i "s/127.0.0.1/0.0.0.0/g" searx/settings.yml \
    && apk del .build-deps \
    && chmod u+x /usr/local/bin/run.sh

CMD ["run.sh"]
