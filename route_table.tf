#--------------------------------------------------
# Route Table for Public Subnets (Web Tier)
#--------------------------------------------------
resource "aws_route_table" "public_web_rt" {
  vpc_id = aws_vpc.dipen_custom-vpc.id # Associate with the custom VPC

  # Define a route that sends all outbound traffic (0.0.0.0/0) to the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0" # Represents all IPv4 addresses (Internet access)
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "Public Web RT" # Tag to identify the Route Table
  }
}

#--------------------------------------------------
# Route Table for Private Subnets (App Tier)
#--------------------------------------------------
resource "aws_route_table" "private_app_rt" {
  vpc_id = aws_vpc.dipen_custom-vpc.id

  # Route all outbound traffic from private subnets to the NAT Gateway (for Internet access)
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat_gw.id
  }

  tags = {
    Name = "Private App RT"
  }
}
