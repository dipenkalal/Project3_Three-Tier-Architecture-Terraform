resource "aws_s3_bucket" "app_code_bucket" {
  bucket = "dipen-app-backend-code"
  force_destroy = true  # optional: destroys all objects if bucket is deleted

  tags = {
    Name = "app-code"
    Environment = "Dev"
  }
}

resource "aws_s3_object" "submit_form" {
  bucket = aws_s3_bucket.app_code_bucket.id
  key    = "submit-form.php"
  source = "./userdata/submit-form.php"
  content_type = "text/x-php"
}

resource "aws_s3_object" "get_employees" {
  bucket = aws_s3_bucket.app_code_bucket.id
  key    = "get-employees.php"
  source = "./userdata/get-employees.php"
  content_type = "text/x-php"
}
