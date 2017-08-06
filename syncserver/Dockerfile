FROM alpine:3.6

ENV SYNC_VERSION=1.6.0
ENV URL=localhost
ENV UID=791 GID=791

EXPOSE 5000

COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache -U python su-exec make libstdc++ \
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
	&& chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]
