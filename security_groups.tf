#--------------------------------------------------
# Security Group for Web Tier
#--------------------------------------------------
resource "aws_security_group" "web_tier_sg" {
  vpc_id     = aws_vpc.dipen_custom-vpc.id
  name       = "web_tier_sg"
  description = "Allow HTTP, HTTPS, and SSH inbound; allow all outbound traffic"

  tags = {
    Name = "web_tier_sg"
  }
}

# Allow inbound HTTPS traffic (port 443) from within the VPC (not from the internet)
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4_web" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0"  # CHANGE: should allow from internet
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# Allow inbound HTTP traffic (port 80) from anywhere (public)
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_web" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0"  # Allow from public internet
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Allow inbound SSH (port 22) from within the VPC or restrict to your IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_web" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0"  # WARNING: too open — change to specific IP for production
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Allow all outbound traffic from web instances
resource "aws_vpc_security_group_egress_rule" "allow_all_web_traffic_ipv4" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"  # All protocols
}

#--------------------------------------------------
# Security Group for App Tier
#--------------------------------------------------
resource "aws_security_group" "app_tier_sg" {
  vpc_id     = aws_vpc.dipen_custom-vpc.id
  name       = "app_tier_sg"
  description = "Allow HTTP from web tier and all outbound traffic"

  tags = {
    Name = "app_tier_sg"
  }
}

# Allow inbound HTTP from Web Tier Security Group only
resource "aws_vpc_security_group_ingress_rule" "allow_http_from_web_sg" {
  security_group_id            = aws_security_group.app_tier_sg.id
  referenced_security_group_id = aws_security_group.web_tier_sg.id  
  from_port                    = 80
  to_port                      = 80
  ip_protocol                  = "tcp"
}

# Allow all outbound traffic from App Tier
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_app" {
  security_group_id = aws_security_group.app_tier_sg.id  
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

#--------------------------------------------------
# Security Group for Database Tier
#--------------------------------------------------
resource "aws_security_group" "db_tier_sg" {
  vpc_id     = aws_vpc.dipen_custom-vpc.id
  name       = "db_tier_sg"
  description = "Allow mysql from app tier and all outbound traffic"

  tags = {
    Name = "db_tier_sg"
  }
}
# Allow inbound HTTP from App Tier Security Group only
resource "aws_vpc_security_group_ingress_rule" "allow_mysql_from_app_sg" {
  security_group_id            = aws_security_group.db_tier_sg.id
  referenced_security_group_id = aws_security_group.app_tier_sg.id  
  from_port                    = 3306
  to_port                      = 3306
  ip_protocol                  = "tcp"
}

# Allow all outbound traffic from App Tier
resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_db" {
  security_group_id = aws_security_group.db_tier_sg.id  
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
