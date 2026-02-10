FROM alpine:3.22

RUN apk add --no-cache nginx openssl bash

RUN mkdir -p /run/nginx

COPY tools/nginx.conf /etc/nginx/nginx.conf
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 443

ENTRYPOINT ["bash", "/setup.sh"]
