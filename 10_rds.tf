# RDS MySQL Database Instance
### @IDX:RDS_MYSQL
resource "aws_db_instance" "mysql_db" {
  identifier          = "mysql-db-project3"
  allocated_storage   = 20                  
  storage_type        = "gp2"               
  instance_class      = var.mysql_config[0] # DB instance type 
  engine              = "mysql"             # MySQL engine
  engine_version      = "8.0.41"            # MySQL version
  deletion_protection = false

  username = "admin"      # DB master username
  password = "90166Dipen" # DB password 
  db_name  = "mydb1"      # Initial DB name

  multi_az = var.mysql_config[2] 
  publicly_accessible = false # Keeps DB private within VPC
  skip_final_snapshot = true  # Do not take final snapshot when deleting

  db_subnet_group_name   = aws_db_subnet_group.mysql_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_tier_sg.id]

  tags = {
    Name    = "MySQL-DB"
    Project = "Three-Tier-Web-App"
    Tier    = "Database"
    Owner   = "Dipen"
  }

}
