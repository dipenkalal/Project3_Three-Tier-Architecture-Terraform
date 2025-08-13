variable "mysql_config" {
  type    = tuple([string, number, bool])
  default = ["db.t4g.micro", 3, false]
}

# variables.tf
variable "aws_region" {
  description = "AWS region for all resources"
  type        = string
  default     = "us-east-2"
}


provider "aws" {
  region = var.aws_region
}


