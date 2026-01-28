#!/bin/bash

# 1. Attente de MariaDB (Indispensable pour éviter que WP crash au boot)
while ! mariadb-admin ping -h"mariadb" --silent; do
    sleep 1
done

# 2. On s'assure que le dossier est prêt
cd /var/www/html

# 3. Téléchargement et installation uniquement si WP n'existe pas déjà
if [ ! -f "wp-settings.php" ]; then
    wp core download --allow-root
    
    # On remplace le config par le tien (copié via le Dockerfile)
    cp ./wp-config.php .

    # Installation du site (Utilise les variables .env et les secrets)
    wp core install --allow-root \
        --url=$DOMAIN_NAME \
        --title="Inception" \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$(cat /run/secrets/wp_password) \
        --admin_email="juhanse@student.42belgium.be" \
        --skip-email

    # Création du second utilisateur requis par le sujet
    wp user create --allow-root \
        $WP_USER "user@student.42belgium.be" \
        --user_pass=$(cat /run/secrets/wp_password) \
        --role=author
fi

# 4. Configuration de PHP-FPM pour Docker (écoute sur le port 9000)
sed -i 's/listen = \/run\/php\/php8.2-fpm.sock/listen = 9000/g' /etc/php/8.2/fpm/pool.d/www.conf

# 5. Création du dossier PID pour PHP (évite les erreurs de lancement)
mkdir -p /run/php

echo "WordPress configuré !"

# 6. Exécution au premier plan (PID 1) - Pas de loops infinies !
exec /usr/sbin/php-fpm8.2 -F
