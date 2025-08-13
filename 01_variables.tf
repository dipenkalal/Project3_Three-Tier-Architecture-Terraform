### @IDX:VAR_MYSQL_CONFIG
variable "mysql_config" {
  type    = tuple([string, number, bool])
  default = ["db.t4g.micro", 3, false]
}

### @IDX:VAR_REGION
variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-2"
}

### @IDX:VAR_WEB_AMI
variable "web_ami" {
  description = "AMI ID for Web Tier EC2"
  type        = string
  default     = "ami-08221e706f343d7b7"
}

### @IDX:VAR_WEB_INSTANCE
variable "web_instance_type" {
  description = "Instance type for Web Tier"
  type        = string
  default     = "t2.micro"
}

### @IDX:VAR_APP_AMI
variable "app_ami" {
  type    = string
  default = "ami-08221e706f343d7b7"
}

### @IDX:VAR_APP_INSTANCE
variable "app_instance_type" {
  description = "Instance type for APP Tier"
  type    = string
  default = "t2.micro"
}

variable "bucket_name" {
  type        = string
  default     = "dipen-app-backend-code"
  description = "S3 bucket with web static files"
}