#!/bin/bash
set -eux
sudo su
dnf -y update
dnf -y install httpd php-fpm php-cli php-mysqlnd awscli

systemctl enable --now php-fpm
systemctl enable --now httpd

# PHP-FPM handler for Apache
cat >/etc/httpd/conf.d/php-fpm.conf <<'CONF'
AddType application/x-httpd-php .php
DirectoryIndex index.php index.html
<FilesMatch \.php$>
  SetHandler "proxy:unix:/run/php-fpm/www.sock|fcgi://localhost/"
</FilesMatch>
CONF

# pull ONLY backend code (you can keep everything in same bucket)
BUCKET="dipen-app-backend-code"
aws s3 sync "s3://${BUCKET}/" /var/www/html/ --delete

chown -R apache:apache /var/www/html
find /var/www/html -type f -exec chmod 0644 {} \;

systemctl restart php-fpm httpd
