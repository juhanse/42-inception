FROM alpine:3.23

RUN apk update && \
    apk add --no-cache vsftpd bash

COPY conf/vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY tools/setup_ftp.sh /usr/local/bin/setup_ftp.sh

RUN chmod +x /usr/local/bin/setup_ftp.sh

EXPOSE 21 21100-21105

CMD ["/usr/local/bin/setup_ftp.sh"]
