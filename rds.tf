#--------------------------------------------------
# RDS MySQL Database Instance
#--------------------------------------------------
resource "aws_db_instance" "mysql_db" {
    identifier = "mysql-db-project3"
  allocated_storage    = 20                      # 20 GB of storage
  storage_type         = "gp2"                   # General Purpose SSD
  instance_class       = var.mysql_config[0]     # DB instance type (from tuple)
  engine               = "mysql"                 # MySQL engine
  engine_version       = "8.0.41"                # MySQL version

  username             = "admin"                 # DB master username
  password             = "90166Dipen"            # DB password 
  db_name              = "mydb1"                 # Initial DB name

  multi_az             = var.mysql_config[2]     # Multi-AZ enabled or not (from tuple)

  publicly_accessible  = false                   # Keeps DB private within VPC
  skip_final_snapshot  = true                    # Do not take final snapshot when deleting

  db_subnet_group_name = aws_db_subnet_group.mysql_db_subnet_group.name
  vpc_security_group_ids = [aws_security_group.db_tier_sg.id]

  tags = {
    Name        = "MySQL-DB"
    Project     = "Three-Tier-Web-App"
    Tier        = "Database"
    Owner       = "Dipen"
  }

}
