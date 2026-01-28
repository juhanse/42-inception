#!/bin/bash

# Création des dossiers nécessaires pour le socket et les logs
mkdir -p /run/mysqld
chown -R mysql:mysql /run/mysqld
mkdir -p /var/log/mysql
chown -R mysql:mysql /var/log/mysql

# Initialisation de la base de données si elle n'existe pas
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initialisation de la base de données..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

# Lecture des secrets
DB_PWD=$(cat /run/secrets/db_password)

# On lance mysqld en arrière-plan temporairement pour configurer les users
mysqld_safe --datadir=/var/lib/mysql &

# On attend que MariaDB soit prêt
until mysqladmin ping >/dev/null 2>&1; do
    echo "Attente de MariaDB..."
    sleep 2
done

# Configuration des utilisateurs (à adapter avec tes variables .env)
mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${DB_PWD}';"
mysql -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
mysql -e "FLUSH PRIVILEGES;"

# On éteint l'instance temporaire proprement
mysqladmin -u root shutdown

# On lance MariaDB au premier plan (obligatoire pour Docker)
echo "Démarrage définitif de MariaDB..."
exec mysqld --user=mysql --datadir=/var/lib/mysql --bind-address=0.0.0.0 --skip-networking=OFF
