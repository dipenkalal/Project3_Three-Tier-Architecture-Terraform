#!/bin/bash
set -eux
sudo su
dnf -y update
dnf -y install httpd awscli
systemctl enable --now httpd

# STATIC ONLY (html/css/js/images)
BUCKET="dipen-app-backend-code"
# If you want, place only static files under a prefix (e.g., /static)
aws s3 sync "s3://${BUCKET}/" /var/www/html/ --delete

# Reverse proxy /api/* to the internal ALB
INTERNAL_APP_ALB="${internal_alb_dns}"  # <- replace via Terraform templatefile or sed

cat >/etc/httpd/conf.d/reverse-proxy.conf <<CONF
ProxyPreserveHost On
ProxyRequests Off

# required modules are in httpd; ensure they load
LoadModule proxy_module modules/mod_proxy.so
LoadModule proxy_http_module modules/mod_proxy_http.so

# forward all /api/* to the app tier
ProxyPass        /api/ http://${INTERNAL_APP_ALB}/
ProxyPassReverse /api/ http://${INTERNAL_APP_ALB}/
CONF

systemctl restart httpd
