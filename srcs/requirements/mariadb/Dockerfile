FROM alpine:3.22

RUN apk add --no-cache mariadb mariadb-client bash

COPY tools/50-server.cnf /etc/my.cnf.d/50-server.cnf
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

ENTRYPOINT ["bash", "/setup.sh"]
