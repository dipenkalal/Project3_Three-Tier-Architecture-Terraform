resource "aws_s3_bucket" "app_code_bucket" {
  bucket        = "dipen-app-backend-code"
  force_destroy = true

  tags = {
    Name        = "app-code"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "submit_form" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "submit-form.php"
  source       = "./userdata/submit-form.php"
  content_type = "text/x-php"
}

resource "aws_s3_object" "get_employees" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "get-employees.php"
  source       = "./userdata/get-employees.php"
  content_type = "text/x-php"
}

resource "aws_s3_object" "health_php" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "health.php"
  source       = "./userdata/health.php"
  content_type = "text/x-php"
}

resource "aws_s3_object" "config_php" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "config.php"
  content_type = "text/x-php"

  content = templatefile("${path.module}/userdata/config.php.tmpl", {
    db_host = aws_db_instance.mysql_db.address
    db_name = aws_db_instance.mysql_db.db_name
    db_user = "admin"
    db_pass = "90166Dipen"
  })
}

resource "aws_s3_object" "form_html" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "form.html"
  source       = "./userdata/form.html"
  content_type = "text/html"
}

resource "aws_s3_object" "view_employees_html" {
  bucket       = aws_s3_bucket.app_code_bucket.id
  key          = "view-employees.html"
  source       = "./userdata/view-employees.html"
  content_type = "text/html"
}

# SSM Parameters
resource "aws_ssm_parameter" "rds_endpoint" {
  name      = "/app/db/endpoint"
  type      = "String"
  value     = aws_db_instance.mysql_db.address
  overwrite = true
}

resource "aws_ssm_parameter" "db_username" {
  name      = "/app/db/username"
  type      = "String"
  value     = "admin"
  overwrite = true
}

resource "aws_ssm_parameter" "db_password" {
  name      = "/app/db/password"
  type      = "SecureString"
  value     = "90166Dipen"
  overwrite = true
}
