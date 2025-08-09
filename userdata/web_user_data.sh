#!/bin/bash
yum update -y
yum install -y httpd php php-mysqlnd aws-cli
systemctl start httpd
systemctl enable httpd

# Fetch files from S3
aws s3 cp s3://dipen-app-backend-code/submit-form.php /var/www/html/submit-form.php
aws s3 cp s3://dipen-app-backend-code/get-employees.php /var/www/html/get-employees.php



systemctl restart httpd