#!/bin/bash

# On force une valeur si jamais l'env est mal chargé pour éviter le crash
if [ -z "$DOMAIN_NAME" ]; then
    DOMAIN_NAME="juhanse.42.fr"
fi

mkdir -p /etc/nginx/ssl

# Génération du certificat
openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/ssl/private/nginx-selfsigned.key \
    -out /etc/ssl/certs/nginx-selfsigned.crt \
    -subj "/C=FR/L=Paris/O=42/OU=student/CN=$DOMAIN_NAME"

# Configuration du fichier Nginx
echo "server {
    listen 443 ssl;
    listen [::]:443 ssl;

    server_name $DOMAIN_NAME;

    ssl_certificate /etc/ssl/certs/nginx-selfsigned.crt;
    ssl_certificate_key /etc/ssl/private/nginx-selfsigned.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    root /var/www/html;
    index index.php index.html;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location ~ \.php$ {
        include fastcgi_params;
        fastcgi_pass wordpress:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
    }
}" > /etc/nginx/sites-available/default

# On s'assure que le lien symbolique existe (Debian standard)
ln -sf /etc/nginx/sites-available/default /etc/nginx/sites-enabled/default

echo "Nginx starting..."
exec nginx -g "daemon off;"
