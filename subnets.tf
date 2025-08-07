#--------------------------------------------------
# Public Subnet in AZ1 (for Web Tier)
#--------------------------------------------------
resource "aws_subnet" "pub_web_az_1" {
  vpc_id                  = aws_vpc.dipen_custom-vpc.id # Associate with the custom VPC
  cidr_block              = "10.0.1.0/24"               # Subnet range (256 IPs)
  availability_zone       = "us-east-2a"                # Availability Zone 1
  map_public_ip_on_launch = true                        # Assign public IP automatically to EC2

  tags = {
    Name = "Public_Web_1" # Tag for easy identification
  }
}

#--------------------------------------------------
# Public Subnet in AZ2 (for Web Tier)
#--------------------------------------------------
resource "aws_subnet" "pub_web_az_2" {
  vpc_id                  = aws_vpc.dipen_custom-vpc.id
  cidr_block              = "10.0.2.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public_Web_2"
  }
}

#--------------------------------------------------
# Private Subnet in AZ1 (for App Tier)
#--------------------------------------------------
resource "aws_subnet" "pri_app_az_1" {
  vpc_id                  = aws_vpc.dipen_custom-vpc.id
  cidr_block              = "10.0.3.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false # Private subnet (no auto public IP)

  tags = {
    Name = "Private_App_1"
  }
}

#--------------------------------------------------
# Private Subnet in AZ2 (for App Tier)
#--------------------------------------------------
resource "aws_subnet" "pri_app_az_2" {
  vpc_id                  = aws_vpc.dipen_custom-vpc.id
  cidr_block              = "10.0.4.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_App_2"
  }
}

#--------------------------------------------------
# Private Subnet in AZ1 (for Database Tier)
#--------------------------------------------------
resource "aws_subnet" "pri_db_az_1" {
  vpc_id                  = aws_vpc.dipen_custom-vpc.id
  cidr_block              = "10.0.5.0/24"
  availability_zone       = "us-east-2a"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_Database_1"
  }
}

#--------------------------------------------------
# Private Subnet in AZ2 (for Database Tier)
#--------------------------------------------------
resource "aws_subnet" "pri_db_az_2" {
  vpc_id                  = aws_vpc.dipen_custom-vpc.id
  cidr_block              = "10.0.6.0/24"
  availability_zone       = "us-east-2b"
  map_public_ip_on_launch = false

  tags = {
    Name = "Private_Database_2"
  }
}
