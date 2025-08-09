resource "aws_instance" "web_server" {
  iam_instance_profile = aws_iam_instance_profile.ec2_s3_profile.name
  ami                    = "ami-08221e706f343d7b7"  # us-east-2 region’s AMI
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.pub_web_az_1.id
  key_name               = aws_key_pair.dipen_keypair.key_name  # <-- Use created key
  vpc_security_group_ids = [aws_security_group.web_tier_sg.id]
  user_data_base64 = filebase64("${path.module}/userdata/app_user_data.sh")


  tags = {
    Name = "web-server-ec2"
  }
}
