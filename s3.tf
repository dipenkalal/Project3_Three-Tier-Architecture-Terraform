resource "aws_s3_bucket" "app_code_bucket" {
  bucket        = "dipen-app-backend-code"
  force_destroy = true # optional: destroys all objects if bucket is deleted

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
    db_host = aws_db_instance.mysql_db.address # <-- live endpoint
    db_name = aws_db_instance.mysql_db.db_name
    db_user = "admin"
    db_pass = "90166Dipen" # (lab only; move to SSM later)
  })


}

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
  value     = "90166Dipen" # better: pass via tfvars or set manually
  overwrite = true
}
