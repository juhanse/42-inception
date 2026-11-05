#!/bin/sh

mkdir -p /var/www/goaccess

echo "Démarrage de GoAccess..."

while true; do
    if [ -f /var/log/nginx/access.log ]; then
        goaccess /var/log/nginx/access.log -o /var/www/goaccess/index.html --log-format=COMBINED
    fi
    sleep 10
done
