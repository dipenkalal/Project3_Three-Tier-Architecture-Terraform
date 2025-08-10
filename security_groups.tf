#--------------------------------------------------
# Security Group for Web Tier
#--------------------------------------------------
resource "aws_security_group" "web_tier_sg" {
  vpc_id      = aws_vpc.dipen_custom-vpc.id
  name        = "web_tier_sg"
  description = "Allow HTTP, HTTPS, and SSH inbound; allow all outbound traffic"

  tags = {
    Name = "web_tier_sg"
  }
}

# Allow inbound HTTPS traffic (port 443) from within the VPC (not from the internet)
resource "aws_vpc_security_group_ingress_rule" "allow_https_ipv4_web" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0" # CHANGE: should allow from internet
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
}

# Allow inbound HTTP traffic (port 80) from anywhere (public)
resource "aws_vpc_security_group_ingress_rule" "allow_http_ipv4_web" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0" # Allow from public internet
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
}

# Allow inbound SSH (port 22) from within the VPC or restrict to your IP
resource "aws_vpc_security_group_ingress_rule" "allow_ssh_ipv4_web" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0" # WARNING: too open — change to specific IP for production
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
}

# Allow all outbound traffic from web instances
resource "aws_vpc_security_group_egress_rule" "allow_all_web_traffic_ipv4" {
  security_group_id = aws_security_group.web_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # All protocols
}

#--------------------------------------------------
# Security Group for App Tier
#--------------------------------------------------
resource "aws_security_group" "app_tier_sg" {
  vpc_id      = aws_vpc.dipen_custom-vpc.id
  name        = "app_tier_sg"
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
  vpc_id      = aws_vpc.dipen_custom-vpc.id
  name        = "db_tier_sg"
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
# resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_db" {
#   security_group_id = aws_security_group.db_tier_sg.id
#   cidr_ipv4         = "0.0.0.0/0"
#   ip_protocol       = "-1"
# }

# ALB SG (only Web tier can hit it)
resource "aws_security_group" "alb_internal_sg" {
  name        = "alb-internal-sg"
  description = "Internal ALB SG"
  vpc_id      = aws_vpc.dipen_custom-vpc.id
  tags        = { Name = "alb-internal-sg" }
}

# Ingress 80 from Web Tier SG
resource "aws_vpc_security_group_ingress_rule" "alb_in_from_web" {
  security_group_id            = aws_security_group.alb_internal_sg.id
  referenced_security_group_id = aws_security_group.web_tier_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

# Egress: ALB -> targets
resource "aws_vpc_security_group_egress_rule" "alb_all_egress" {
  security_group_id = aws_security_group.alb_internal_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

# App SG must allow 80 from ALB (not from Web)
resource "aws_vpc_security_group_ingress_rule" "app_http_from_alb" {
  security_group_id            = aws_security_group.app_tier_sg.id
  referenced_security_group_id = aws_security_group.alb_internal_sg.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

# Target group
resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.dipen_custom-vpc.id

  health_check {
    path                = "/health.php"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = { Name = "app-tg" }
}

# Internal ALB across private app subnets
resource "aws_lb" "app_internal_alb" {
  name                       = "app-internal-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_internal_sg.id]
  subnets                    = [aws_subnet.pri_app_az_1.id, aws_subnet.pri_app_az_2.id]
  enable_deletion_protection = false
  tags                       = { Name = "app-internal-alb" }
}

# Listener
resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app_internal_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

output "internal_alb_dns" {
  value       = aws_lb.app_internal_alb.dns_name
  description = "DNS name of the internal ALB"
}


variable "app_ami" {
  type    = string
  default = "ami-08221e706f343d7b7"
}

variable "app_instance_type" {
  type    = string
  default = "t2.micro"
}

resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = var.app_ami
  instance_type = var.app_instance_type

  vpc_security_group_ids = [aws_security_group.app_tier_sg.id]
  key_name = aws_key_pair.dipen_keypair.key_name   # <-- IMPORTANT

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_profile.name
  }

  user_data = filebase64("${path.module}/userdata/app_user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "app-tier-ec2" }
  }
}

resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  min_size                  = 1
  desired_capacity          = 2
  max_size                  = 4
  vpc_zone_identifier       = [aws_subnet.pri_app_az_1.id, aws_subnet.pri_app_az_2.id]
  health_check_type         = "ELB"
  health_check_grace_period = 90
  target_group_arns         = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

instance_refresh {
    strategy = "Rolling"
    preferences { 
      min_healthy_percentage = 90 
    instance_warmup = 60 
    }
    triggers = ["launch_template"]
  }
  tag {
    key                 = "Name"
    value               = "app-tier-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}


# resource "aws_vpc_security_group_ingress_rule" "db_from_app" {
#   security_group_id            = aws_security_group.db_tier_sg.id
#   referenced_security_group_id = aws_security_group.app_tier_sg.id
#   ip_protocol                  = "tcp"
#   from_port                    = 3306
#   to_port                      = 3306
# }

resource "aws_vpc_security_group_egress_rule" "db_all_egress" {
  security_group_id = aws_security_group.db_tier_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}

