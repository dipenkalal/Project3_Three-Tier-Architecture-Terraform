#--------------------------------------------
# Generate a new SSH key pair locally
#--------------------------------------------
resource "tls_private_key" "dipen_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

#--------------------------------------------
# Create AWS EC2 Key Pair using public key
#--------------------------------------------
resource "aws_key_pair" "dipen_keypair" {
  key_name   = "dipen-keypair"  # Used in EC2 instance
  public_key = tls_private_key.dipen_key.public_key_openssh
}


resource "local_file" "save_private_key" {
  content  = tls_private_key.dipen_key.private_key_pem
  filename = "${path.module}/dipen-keypair.pem"
  file_permission = "0600"
}

