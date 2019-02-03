FROM alpine:3.9
RUN apk add --no-cache -U s6 su-exec tini
ENTRYPOINT ["/sbin/tini", "-s", "--"]

ARG GLANCES_VERSION=v3.1.0
ENV CACHED_TIME=15
ENV GLANCES_OPT=""
EXPOSE 61208
WORKDIR /glances

COPY s6.d /etc/s6.d
COPY glances.conf /glances/glances.conf
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache python3 py3-psutil py3-bottle docker-py \
    && apk add --no-cache --virtual .build-deps tar ca-certificates openssl wget \
    && wget -qO- https://github.com/nicolargo/glances/archive/${GLANCES_VERSION}.tar.gz | tar xz --strip 1 \
    && apk del .build-deps \
    && mkdir -p /var/run \
    && chmod +x /usr/local/bin/run.sh

CMD ["run.sh"]
