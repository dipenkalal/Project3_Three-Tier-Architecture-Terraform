### @IDX:S3_BUCKET_CREATION
resource "aws_s3_bucket" "app_code_bucket" {
  bucket        = "dipen-app-backend-code"
  force_destroy = true
  tags = {
    Name        = "app-code"
    Environment = "Dev"
  }
}

### @IDX:LOCALS
locals {
  app_code_dir = "${path.module}/codebase"
  
  app_files = [
    for f in fileset(local.app_code_dir, "*") :
    f
    if !can(regex("\\.tmpl$", f))
    && f != "submit-form.php"
    && f != "get-employees.php"
  ]

  mime_map = {
    html = "text/html"
    php  = "text/x-php"
    txt  = "text/plain"
  }
}

### @IDX:S3_FILES
resource "aws_s3_object" "app_files" {
  for_each     = { for f in local.app_files : f => f }
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = each.value
  source       = "${local.app_code_dir}/${each.value}"
  content_type = lookup(local.mime_map, reverse(split(".", each.value))[0], "binary/octet-stream")
  etag         = filemd5("${local.app_code_dir}/${each.value}")
}

# Rendered from templates 
### @IDX:S3_FILE_SUBMIT_FORM
resource "aws_s3_object" "submit_form" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "submit-form.php"
  content_type = "text/x-php"
  content = templatefile("${path.module}/codebase/submit-form.php.tmpl", {
    db_host = aws_db_instance.mysql_db.address
    db_name = aws_db_instance.mysql_db.db_name
    db_user = "admin"
    db_pass = "90166Dipen"
  })
}

### @IDX:S3_FILE_GET_EMPLOYEES
resource "aws_s3_object" "get_employees" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "get-employees.php"
  content_type = "text/x-php"
  content = templatefile("${path.module}/codebase/get-employees.php.tmpl", {
    db_host = aws_db_instance.mysql_db.address
    db_name = aws_db_instance.mysql_db.db_name
    db_user = "admin"
    db_pass = "90166Dipen"
  })
}

### @IDX:S3_FILE_CONFIG
resource "aws_s3_object" "config_php" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "config.php"
  content_type = "text/x-php"
  content = templatefile("${path.module}/codebase/config.php.tmpl", {
    db_host = aws_db_instance.mysql_db.address
    db_name = aws_db_instance.mysql_db.db_name
    db_user = "admin"
    db_pass = "90166Dipen"
  })
}

### @IDX:SSM_PARAM_RDS_ENDPOINT
resource "aws_ssm_parameter" "rds_endpoint" {
  name      = "/app/db/endpoint"
  type      = "String"
  value     = aws_db_instance.mysql_db.address
  overwrite = true
}

### @IDX:SSM_PARAM_DB_USERNAME
resource "aws_ssm_parameter" "db_username" {
  name      = "/app/db/username"
  type      = "String"
  value     = "admin"
  overwrite = true
}

### @IDX:SSM_PARAM_DB_PASSWORD
resource "aws_ssm_parameter" "db_password" {
  name      = "/app/db/password"
  type      = "SecureString"
  value     = "90166Dipen"
  overwrite = true
}
