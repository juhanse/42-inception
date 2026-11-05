#!/bin/bash
set -e

FTP_PASS_PATH="/run/secrets/ftp_password"

if [ ! -f "$FTP_PASS_PATH" ]; then
    echo "❌ FTP: Le fichier de secret est introuvable"
    exit 1
fi

FTP_PASSWORD=$(cat "$FTP_PASS_PATH" | tr -d '\n\r')

if [ -z "$FTP_USER" ]; then
    echo "❌ FTP: Variable d'environnement requise manquante."
    exit 1
fi

if ! id "$FTP_USER" &>/dev/null; then
    mkdir -p /var/www/html
    adduser -D -h /var/www/html -s /bin/bash "$FTP_USER"
    echo "$FTP_USER:$FTP_PASSWORD" | chpasswd
    
    mkdir -p /etc/vsftpd
    echo "$FTP_USER" >> /etc/vsftpd/vsftpd.userlist
fi

mkdir -p /var/run/vsftpd/empty
chown -R "$FTP_USER":"$FTP_USER" /var/www/html

exec vsftpd /etc/vsftpd/vsftpd.conf
