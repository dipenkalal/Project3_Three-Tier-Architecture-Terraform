#!/bin/bash
set -xe
exec > /var/log/user-data-web.log 2>&1
sudo su
sudo yum update -y
sudo yum install -y httpd
sudo systemctl start httpd
sudo systemctl enable httpd

sudo systemctl enable --now httpd

aws s3 cp s3://dpen-app-backend-code/index.html /var/www/html/index.html
aws s3 cp s3://dipen-app-backend-code/form.html /var/www/html/form.html
aws s3 cp s3://dipen-app-backend-code/view-employees.html /var/www/html/view-employees.html
aws s3 cp s3://dpen-app-backend-code/health.php /var/www/html/health.php

sudo chmod 644 /var/www/html/health.php
sudo systemctl restart httpd
