#--------------------------------------------------
# Create a Custom VPC named "Dipen Custom VPC"
#--------------------------------------------------

resource "aws_vpc" "dipen_custom-vpc" {
  # The CIDR block for the VPC – defines the IP address range
  cidr_block = "10.0.0.0/16" # Allows 65,536 IP addresses

  # Enables DNS hostnames for instances launched in this VPC
  enable_dns_hostnames = true

  # Enables DNS support so that DNS queries work within the VPC
  enable_dns_support = true

  # Tag the VPC with a human-readable name for easier identification
  tags = {
    Name = "Dipen Custom VPC"
  }
}
