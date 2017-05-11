FROM alpine:latest
LABEL Description="Simple and lightweight firefox syncserver docker container, based on alpine linux." Version="0.1"

ENV SYNC_VERSION=1.6.0
ENV URL=localhost
ENV UID=791
ENV GID=791

COPY run.sh /usr/local/bin/run.sh

# install the required packages
RUN set -xe \
    && apk add --no-cache -U python tini su-exec make libstdc++ \
    && apk add --no-cache --virtual .build-deps py-pip py-virtualenv g++ gcc python-dev openssl \
    && mkdir /sync \
	&& cd /sync \
	&& wget https://github.com/mozilla-services/syncserver/archive/$SYNC_VERSION.tar.gz \
    && tar -xzf $SYNC_VERSION.tar.gz \
	&& rm -f $SYNC_VERSION.tar.gz \
    && mv syncserver-$SYNC_VERSION server \
	&& cd server \
    && make build \
    && apk del .build-deps \
	&& chmod u+x /usr/local/bin/run.sh

EXPOSE 5000

ENTRYPOINT ["/sbin/tini", "--"]

CMD ["run.sh"]
