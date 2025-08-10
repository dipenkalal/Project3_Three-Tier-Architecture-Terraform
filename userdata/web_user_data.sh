#!/bin/bash
set -xe
exec > /var/log/user-data-web.log 2>&1

yum update -y
yum install -y httpd

systemctl enable --now httpd

# example placeholder homepage
cat >/var/www/html/index.html <<'HTML'
<!doctype html><html><body>
<h1>Web Tier</h1>
<p>This server will proxy to the internal ALB.</p>
</body></html>
HTML

systemctl restart httpd
