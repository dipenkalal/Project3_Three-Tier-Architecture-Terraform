# Output: RDS MySQL Endpoint, Port, and DB Name, DNS Internal ALB, DNS Web ALB
### @IDX:RDS_MYSQL_ENDPOINT
output "rds_mysql_endpoint" {
  description = "The connection endpoint for the RDS MySQL database"
  value       = aws_db_instance.mysql_db.endpoint
}

### @IDX:RDS_MYSQL_POINT
output "rds_mysql_port" {
  description = "The port the RDS MySQL database is listening on"
  value       = aws_db_instance.mysql_db.port
}

### @IDX:RDS_MYSQL_NAME
output "rds_mysql_db_name" {
  description = "The name of the MySQL database"
  value       = aws_db_instance.mysql_db.db_name
}

output "private_key_pem" {
  value     = tls_private_key.dipen_key.private_key_pem
  sensitive = true
}

### @IDX:INTERNAL_ALB_DNS_NAME
output "internal_alb_dns" {
  description = "DNS name of the internal Application Load Balancer"
  value       = aws_lb.app_internal_alb.dns_name
}

### @IDX:PUBLIC_ALB_DNS_NAME
output "web_alb_dns_name" {
  value       = aws_lb.web_alb.dns_name
  description = "Public DNS of the Web Tier ALB"
}

