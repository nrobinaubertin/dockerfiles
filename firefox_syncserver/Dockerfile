FROM alpine:3.7

ARG SYNC_VERSION=1.8.0
ENV URL=localhost
ENV UID=791 GID=791
ENV FORCE_WSGI=false

EXPOSE 5000

WORKDIR /sync

COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache -U python2 su-exec make libstdc++ openssl \
    && apk add --no-cache --virtual .build-deps py2-pip g++ gcc python2-dev openssl py2-virtualenv libffi-dev openssl-dev \
	&& wget -qO- https://github.com/mozilla-services/syncserver/archive/${SYNC_VERSION}.tar.gz | tar xz --strip 1 \
    && make build \
    && apk del .build-deps \
	&& chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]
