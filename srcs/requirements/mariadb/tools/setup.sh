#!/bin/bash

echo "MariaDB: Démarrage de l'initialisation..."

DB_PASS_PATH="/run/secrets/db_password"
DB_ROOT_PASS_PATH="/run/secrets/db_root_password"

if [ ! -f "$DB_PASS_PATH" ] || [ ! -f "$DB_ROOT_PASS_PATH" ]; then
    echo "❌ MariaDB: Le fichier de secret est introuvable"
    exit 1
fi

SQL_PASSWORD=$(cat "$DB_PASS_PATH" | tr -d '\n\r')
SQL_ROOT_PASSWORD=$(cat "$DB_ROOT_PASS_PATH" | tr -d '\n\r')

if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || [ -z "$SQL_PASSWORD" ]; then
    echo "❌ MariaDB: Variables d'environnement requises manquantes."
    exit 1
fi

# Initialisation du dossier de données
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "MariaDB: Premier lancement, initialisation du dossier système..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql --skip-test-db > /dev/null
fi

# Démarrage temporaire de MariaDB pour configuration
# Utilisation de --skip-networking pour que personne ne se connecte pendant qu'on règle les MDP
/usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking &
PID="$!"

echo "MariaDB: Connexion à la base de données..."

# Attendre que MariaDB soit prêt à accepter des connexions
MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    if mariadb-admin ping --silent; then
        echo "✅ MariaDB: Connexion à la base de données établie !"
        break
    fi
    echo "MariaDB: En attente... Tentative $((COUNT + 1))/$MAX_RETRIES"
    sleep 2
    COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
    echo "❌ MariaDB: Échec de la connexion à la base de données après $MAX_RETRIES tentatives."
    exit 1
fi

echo "MariaDB: Configuration des accès..."
mariadb -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

# Arrêt propre du serveur temporaire
echo "MariaDB: Redémarrage en mode production..."
mariadb-admin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

# Lancement final en avant-plan (PID 1)
# mysqld est préférable à mysqld_safe dans un conteneur pour la gestion des signaux
exec /usr/bin/mysqld --user=mysql --datadir=/var/lib/mysql --console
