#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    mariadb-install-db --user=mysql --basedir=/usr --datadir=/var/lib/mysql > /dev/null
fi

service mysql start 

echo "CREATE DATABASE IF NOT EXISTS $mariadb_name ;" > mariadb.sql
echo "CREATE USER IF NOT EXISTS '$mariadb_user'@'%' IDENTIFIED BY '$mariadb_pwd' ;" >> mariadb.sql
echo "GRANT ALL PRIVILEGES ON $mariadb_name.* TO '$mariadb_user'@'%' ;" >> mariadb.sql
echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '12345' ;" >> mariadb.sql
echo "FLUSH PRIVILEGES;" >> mariadb.sql

mysql < mariadb.sql

kill $(cat /var/run/mysqld/mysqld.pid)

mysqld
