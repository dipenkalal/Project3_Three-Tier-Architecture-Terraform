# Internet Gateway for Public Subnets
### @IDX:INTERNET_GATEWAY
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.dipen_custom_vpc.id

  tags = {
    Name = "dipen_vpc_igw" # Tag for easy identification
  }
}


# Elastic IP for NAT Gateway
### @IDX:ELASTIC_IP_CREATION
resource "aws_eip" "nat_gw_ip" {
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway for Private Subnets
### @IDX:NAT_GATEWAY
resource "aws_nat_gateway" "nat_gw" {
  # NAT Gateway must be created in a public subnet to allow outbound Internet access
  subnet_id = aws_subnet.pub_web_az_1.id 
  allocation_id = aws_eip.nat_gw_ip.id

  tags = {
    Name = "dipen_vpc_Nat_gw"
  }
}
