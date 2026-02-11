FROM alpine:3.22

RUN apk add --no-cache mariadb mariadb-client bash
RUN mkdir -p /run/mysqld /var/lib/mysql
RUN chown -R mysql:mysql /run/mysqld /var/lib/mysql

COPY tools/50-server.cnf /etc/my.cnf.d/mariadb-server.cnf
COPY tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["bash", "/setup.sh"]
