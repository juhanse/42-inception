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

service mariadb start
echo "MariaDB: Connexion à la base de données..."

# Attendre que MariaDB soit prêt à accepter des connexions
MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    if mysqladmin ping -h"localhost" --silent; then
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

echo "MariaDB: Création de la base de données et des utilisateurs..."

# Définir le mot de passe root
mysql -u root << EOF
ALTER USER 'root'@'localhost' IDENTIFIED BY '${SQL_ROOT_PASSWORD}';
FLUSH PRIVILEGES;
EOF

# Utiliser le mot de passe root pour la configuration suivante
mysql -u root -p"${SQL_ROOT_PASSWORD}" << EOF
CREATE DATABASE IF NOT EXISTS \`${SQL_DATABASE}\`;
CREATE USER IF NOT EXISTS '${SQL_USER}'@'%' IDENTIFIED BY '${SQL_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${SQL_DATABASE}\`.* TO '${SQL_USER}'@'%';
FLUSH PRIVILEGES;
EOF

echo "✅ MariaDB: Configuration de la base de données terminée !"

# Arrêt de MariaDB pour un redémarrage en mode production
echo "MariaDB: Démarrage en avant-plan..."
mysqladmin -u root -p"${SQL_ROOT_PASSWORD}" shutdown

sleep 2

# Démarrer MariaDB en avant-plan (foreground)
exec mysqld_safe
