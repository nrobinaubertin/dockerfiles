FROM alpine:3.8
RUN apk add --no-cache -U su-exec tini s6
ENTRYPOINT ["/sbin/tini", "--"]

ARG LUTIM_VERSION=0.11.3
EXPOSE 8080
ENV UID=791 GID=791
ENV CONTACT=admin@example.com
ENV MAX_FILE_SIZE="30*1024*1024"
ENV MAX_DELAY=0

WORKDIR /lutim

COPY s6.d /etc/s6.d
COPY run.sh /usr/local/bin/run.sh

RUN set -xe \
    && apk add --no-cache perl libressl libidn perl-crypt-rijndael perl-test-manifest perl-dbi imagemagick6 imagemagick6-dev shared-mime-info perl-dbd-sqlite \
    && apk add --no-cache --virtual .build-deps build-base libressl-dev ca-certificates perl-dev libidn-dev perl-devel-checklib sqlite-dev perl-dbd-sqlite-dev zlib-dev gnupg postgresql-libs postgresql-dev mariadb-dev \
    && wget -qO- https://framagit.org/fiat-tux/hat-softwares/lutim/-/archive/${LUTIM_VERSION}/lutim-${LUTIM_VERSION}.tar.gz | tar xz --strip 1 \
    && cpan install Carton \
    && echo "requires 'Image::Magick';" >> /lutim/cpanfile \
    && carton install \
    && apk del .build-deps && rm -rf /tmp/* /root/.cpan* /lutim/local/cache/* \
    && mkdir -p /lutim/data /lutim/files \
    && chmod -R +x /usr/local/bin /etc/s6.d

COPY lutim.conf /lutim/lutim.conf

VOLUME ["/lutim/data", "/lutim/files"]

CMD ["run.sh"]
