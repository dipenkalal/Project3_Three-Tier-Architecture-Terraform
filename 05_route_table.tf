# Route Table for Public Subnets (Web Tier)
### @IDX:PUBLIC_RT_WEB
resource "aws_route_table" "public_web_rt" {
  vpc_id = aws_vpc.dipen_custom_vpc.id # Associate with the custom VPC

  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Web RT" # Tag to identify the Route Table
  }
}

# Route Table for Private Subnets (App Tier)
### @IDX:PRIVATE_RT_APP
resource "aws_route_table" "private_app_rt" {
  vpc_id = aws_vpc.dipen_custom_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private App RT"
  }
}
