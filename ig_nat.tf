#--------------------------------------------------
# Internet Gateway for Public Subnets
#--------------------------------------------------
resource "aws_internet_gateway" "igw" {
  # Attach the Internet Gateway to the custom VPC
  vpc_id = aws_vpc.dipen_custom-vpc.id

  tags = {
    Name = "dipen_vpc_igw" # Tag for easy identification
  }
}

#--------------------------------------------------
# Elastic IP for NAT Gateway
#--------------------------------------------------
resource "aws_eip" "nat_gw_ip" {
  # Ensures Internet Gateway is created before allocating the Elastic IP
  depends_on = [aws_internet_gateway.igw]
}

#--------------------------------------------------
# NAT Gateway for Private Subnets
#--------------------------------------------------
resource "aws_nat_gateway" "nat_gw" {
  # NAT Gateway must be created in a public subnet to allow outbound Internet access
  subnet_id = aws_subnet.pub_web_az_1.id # FIX: should be a public subnet, not private

  # Allocate the previously created Elastic IP to this NAT Gateway
  allocation_id = aws_eip.nat_gw_ip.id

  tags = {
    Name = "dipen_vpc_Nat_gw"
  }
}
