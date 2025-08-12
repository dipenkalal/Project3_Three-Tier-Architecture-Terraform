resource "aws_lb" "web_alb" {
  name               = "web-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.web_alb_sg.id]
  subnets = [
    aws_subnet.pub_web_az_1.id,
    aws_subnet.pub_web_az_2.id
  ]
  tags = { Name = "web-tier-alb" }
}

resource "aws_lb_target_group" "web_tg" {
  name     = "web-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.dipen_custom-vpc.id # <-- ensure this matches your actual TF identifier

  health_check {
    path                = "/" # <-- use "/" unless you really have /health.php
    protocol            = "HTTP"
    matcher             = "200-399" # <-- broader = fewer false negatives
    interval            = 15
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
  }

  tags = { Name = "web-tier-tg" }
}

resource "aws_lb_listener" "web_listener" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}

variable "web_ami" {
  description = "AMI ID for Web Tier EC2"
  type        = string
  default     = "ami-08221e706f343d7b7"
}

variable "web_instance_type" {
  description = "Instance type for Web Tier"
  type        = string
  default     = "t2.micro"
}

resource "aws_launch_template" "web_lt" {
  name_prefix   = "web-lt-"
  image_id      = var.web_ami
  instance_type = var.web_instance_type
  key_name      = aws_key_pair.dipen_keypair.key_name
  vpc_security_group_ids = [aws_security_group.web_tier_sg.id]

  iam_instance_profile { name = aws_iam_instance_profile.ec2_s3_profile.name }

user_data = base64encode(templatefile("${path.module}/userdata/web_user_data.sh.tmpl", {
  internal_alb_dns = aws_lb.app_internal_alb.dns_name
}))

  tag_specifications {
    resource_type = "instance"
    tags = { Name = "web-tier-ec2" }
  }
}

resource "aws_autoscaling_group" "web_asg" {
  name                = "web-asg"
  min_size            = 1
  desired_capacity    = 1
  max_size            = 3
  vpc_zone_identifier = [aws_subnet.pub_web_az_1.id, aws_subnet.pub_web_az_2.id]

  # Keep ONE attachment method; this is enough:
  target_group_arns = [aws_lb_target_group.web_tg.arn]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 60
    }
    triggers = ["launch_template"]
  }

  tag {
    key                 = "Name"
    value               = "web-tier-ec2"
    propagate_at_launch = true
  }

  lifecycle {
    create_before_destroy = true
  }
}

/* Remove this to avoid double attachment
resource "aws_autoscaling_attachment" "web_asg_alb" {
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  lb_target_group_arn    = aws_lb_target_group.web_tg.arn
}
*/


