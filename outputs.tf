#--------------------------------------------------
# Output: RDS MySQL Endpoint, Port, and DB Name
#--------------------------------------------------
output "rds_mysql_endpoint" {
  description = "The connection endpoint for the RDS MySQL database"
  value       = aws_db_instance.mysql_db.endpoint
}

output "rds_mysql_port" {
  description = "The port the RDS MySQL database is listening on"
  value       = aws_db_instance.mysql_db.port
}

output "rds_mysql_db_name" {
  description = "The name of the MySQL database"
  value       = aws_db_instance.mysql_db.db_name
}

output "private_key_pem" {
  value     = tls_private_key.dipen_key.private_key_pem
  sensitive = true
}

output "app_instance_private_ip" {
  value = aws_instance.app_server.private_ip
}

output "app_instance_public_ip" {
  value = aws_instance.web_server.public_ip
}

output "rds_endpoint" {
  value = aws_db_instance.mysql_db.endpoint
}

output "internal_alb_dns_1" {
  description = "DNS name of the internal Application Load Balancer"
  value       = aws_lb.app_internal_alb.dns_name
}
# output "iam_instance_profile" {
#   value = aws_iam_instance_profile.instance_profile_name.name
# }

output "web_alb_dns_name" {
  value = aws_lb.web_alb.dns_name
  description = "Public DNS of the Web Tier ALB"
}

output "web_alb_dns" {
  value = aws_lb.web_alb.dns_name
}
