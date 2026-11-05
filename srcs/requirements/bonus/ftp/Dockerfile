FROM alpine:3.23

RUN apk update && \
    apk add --no-cache vsftpd bash

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/setup.sh /usr/local/bin/setup.sh

RUN chmod +x /usr/local/bin/setup.sh

EXPOSE 21 21100-21105

CMD ["/usr/local/bin/setup.sh"]
