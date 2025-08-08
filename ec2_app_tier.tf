# user_data = filebase64("scripts/app-init.sh")

resource "aws_instance" "app_server" {
  ami                    = "ami-08221e706f343d7b7"
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pri_app_az_1.id
  key_name               = aws_key_pair.dipen_keypair.key_name
  vpc_security_group_ids = [aws_security_group.app_tier_sg.id]
  associate_public_ip_address = false

  user_data = filebase64("./userdata/app_user_data.sh")

  tags = {
    Name = "app-tier-ec2"
  }
}
