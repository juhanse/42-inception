#!/bin/bash

echo "WordPress: Démarrage de l'initialisation..."

DB_PASS_PATH="/run/secrets/db_password"
WP_PASS_PATH="/run/secrets/wp_password"

if [ ! -f "$DB_PASS_PATH" ] || [ ! -f "$WP_PASS_PATH" ]; then
    echo "❌ WordPress: Le fichier de secret est introuvable"
    exit 1
fi

SQL_PASSWORD=$(cat "$DB_PASS_PATH" | tr -d '\n\r')
WP_ADMIN_PASSWORD=$(cat "$WP_PASS_PATH" | tr -d '\n\r')

if [ -z "$SQL_DATABASE" ] || [ -z "$SQL_USER" ] || \
	[ -z "$SQL_PASSWORD" ] || [ -z "$DOMAIN_NAME" ] || \
	[ -z "$WP_ADMIN_USER" ] || [ -z "$WP_ADMIN_PASSWORD" ] || \
	[ -z "$WP_ADMIN_EMAIL" ] || [ -z "$WP_USER" ] || \
	[ -z "$WP_USER_EMAIL" ] || [ -z "$WP_USER_PASSWORD" ]; then
    echo "❌ WordPress: Variables d'environnement requises manquantes."
    exit 1
fi

# Temps d'attente pour s'assurer que MariaDB est bien lancé
echo "WordPress: Connexion à la base de données..."
sleep 10

# Vérifie que la base de données est prête à accepter les connexions
MAX_RETRIES=30
COUNT=0
while [ $COUNT -lt $MAX_RETRIES ]; do
    if mysqladmin ping -h"mariadb" -u"$SQL_USER" -p"$SQL_PASSWORD" --silent; then
        echo "✅ WordPress: Connexion à la base de données établie !"
        break
    fi
    echo "WordPress: En attente que MariaDB soit prêt... Tentative $((COUNT + 1))/$MAX_RETRIES"
    sleep 2
    COUNT=$((COUNT + 1))
done

if [ $COUNT -eq $MAX_RETRIES ]; then
    echo "❌ WordPress: Échec de la connexion à la base de données après $MAX_RETRIES tentatives."
    exit 1
fi

# Vérifie si WordPress est déjà installé (pour éviter une double initialisation)
if [ ! -f /var/www/html/wp-config.php ]; then
    echo "WordPress: Téléchargement de WordPress..."
    wp core download --version=6.0 --locale=fr_FR --allow-root

    echo "WordPress: Création du fichier wp-config.php..."
    wp config create --allow-root \
        --dbname="${SQL_DATABASE}" \
        --dbuser="${SQL_USER}" \
        --dbpass="${SQL_PASSWORD}" \
        --dbhost="mariadb:3306" \
        --path="/var/www/html/"

    echo "WordPress: Installation de WordPress..."
    wp core install --allow-root \
        --url="${DOMAIN_NAME}" \
        --title="Inception - juhanse" \
        --admin_user="${WP_ADMIN_USER}" \
        --admin_password="${WP_ADMIN_PASSWORD}" \
        --admin_email="${WP_ADMIN_EMAIL}" \
        --path="/var/www/html/"

    echo "WordPress: Création de l'utilisateur ${WP_USER}..."
    wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
        --user_pass="${WP_USER_PASSWORD}" \
        --role=author \
        --allow-root \
        --path="/var/www/html/"
else
    echo "WordPress: WordPress est déjà installé"
fi

# Création du dossier requis par PHP-FPM si besoin
mkdir -p /run/php82

# Droits d'accès pour NGINX/PHP
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

# Lancement de PHP-FPM en avant-plan (pour que le container reste actif)
echo "WordPress: Démarrage de PHP-FPM…"
sleep 2

# -F pour foreground, obligatoire pour Docker
exec /usr/sbin/php-fpm82 -F
