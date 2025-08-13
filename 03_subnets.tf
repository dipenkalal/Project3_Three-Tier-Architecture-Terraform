# Public Subnet in AZ1 (for Web Tier)
### @IDX:PUBLIC_SUBNET_1
resource "aws_subnet" "pub_web_az_1" {
  vpc_id                  = aws_vpc.dipen_custom_vpc.id 
  cidr_block              = "10.0.1.0/24"               
  availability_zone       = "us-east-2a"              
  map_public_ip_on_launch = true                        

  tags = {
    Name = "Public_Web_1"
  }
}

# Public Subnet in AZ2 (for Web Tier)
### @IDX:PUBLIC_SUBNET_2
resource "aws_subnet" "pub_web_az_2" {
  vpc_id                  = aws_vpc.dipen_custom_vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Web_2"
  }
}

# Private Subnet in AZ1 (for App Tier)
### @IDX:PRIVATE_SUBNET_APP_1
resource "aws_subnet" "pri_app_az_1" {
  vpc_id                  = aws_vpc.dipen_custom_vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false 

  tags = {
    Name = "Private_App_1"
  }
}

# Private Subnet in AZ2 (for App Tier)
### @IDX:PRIVATE_SUBNET_APP_2
resource "aws_subnet" "pri_app_az_2" {
  vpc_id                  = aws_vpc.dipen_custom_vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_App_2"
  }
}

# Private Subnet in AZ1 (for Database Tier)
### @IDX:PRIVATE_SUBNET_DB_1
resource "aws_subnet" "pri_db_az_1" {
  vpc_id                  = aws_vpc.dipen_custom_vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_Database_1"
  }
}

# Private Subnet in AZ2 (for Database Tier)
### @IDX:PRIVATE_SUBNET_DB_2
resource "aws_subnet" "pri_db_az_2" {
  vpc_id                  = aws_vpc.dipen_custom_vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_Database_2"
  }
}

# DB Subnet Group: Used to place RDS in private subnets
resource "aws_db_subnet_group" "mysql_db_subnet_group" {
  name = "mysql-db-subnet-group"
  subnet_ids = [
    aws_subnet.pri_db_az_1.id,
    aws_subnet.pri_db_az_2.id
  ]

  tags = {
    Name = "mysql-db-subnet-group"
    Tier = "Database"
  }
}
