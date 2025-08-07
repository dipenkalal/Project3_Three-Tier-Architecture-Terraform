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
