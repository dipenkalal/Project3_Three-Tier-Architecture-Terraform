# Create a Custom VPC named "Dipen Custom VPC"
### @IDX:VPC_CREATION
resource "aws_vpc" "dipen_custom_vpc" {
  cidr_block = "10.0.0.0/16" # Allows 65,536 IP addresses
  enable_dns_hostnames = true
  enable_dns_support = true

 
  tags = {
    Name = "Dipen Custom VPC"
  }
}
