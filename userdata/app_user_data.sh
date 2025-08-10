#!/bin/bash
set -xe
exec > /var/log/user-data-app.log 2>&1

yum update -y
yum install -y httpd php php-mysqlnd aws-cli jq
systemctl enable --now httpd

S3_BUCKET="dipen-app-backend-code"
aws s3 cp s3://$S3_BUCKET/health.php         /var/www/html/health.php
aws s3 cp s3://$S3_BUCKET/submit-form.php    /var/www/html/submit-form.php
aws s3 cp s3://$S3_BUCKET/get-employees.php  /var/www/html/get-employees.php
# aws s3 cp s3://$S3_BUCKET/config.php

REGION="${REGION:-us-east-2}"
DB_HOST=$(aws ssm get-parameter --name "/app/db/endpoint"  --query Parameter.Value --output text --region $REGION)
DB_USER=$(aws ssm get-parameter --name "/app/db/username"  --query Parameter.Value --output text --region $REGION)
DB_PASS=$(aws ssm get-parameter --name "/app/db/password"  --with-decryption --query Parameter.Value --output text --region $REGION)
DB_NAME="mydb1"

cat >/var/www/html/config.php <<PHP
<?php
\$db_host = "$DB_HOST";
\$db_name = "$DB_NAME";
\$db_user = "$DB_USER";
\$db_pass = "$90166Dipen";
function db_connect() {
  global \$db_host, \$db_user, \$db_pass, \$db_name;
  \$conn = new mysqli(\$db_host, \$db_user, \$db_pass, \$db_name);
  if (\$conn->connect_error) { http_response_code(500); die("DB connect failed: " . \$conn->connect_error); }
  return \$conn;
}
PHP

chown apache:apache /var/www/html/*.php || true
chmod 0644 /var/www/html/*.php || true
systemctl restart httpd
