FROM httpd:2.4-alpine
COPY theme /usr/local/apache2/theme
COPY httpd.conf /usr/local/apache2/conf/httpd.conf
COPY httpd-ssl.conf /usr/local/apache2/conf/httpd-ssl.conf
COPY run.sh /usr/local/bin/run.sh
RUN set -xe \
    && chmod +x /usr/local/bin/* \
    && chmod 755 -R /usr/local/apache2

CMD "run.sh"
ENV CERTFILE=
ENV KEYFILE=
