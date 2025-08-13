### @IDX:APP_TG
resource "aws_lb_target_group" "app_tg" {
  name        = "app-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.dipen_custom_vpc.id

  health_check {
    path                = "/health.php"
    matcher             = "200-399"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = { Name = "app-tg" }
}

# Internal ALB across private app subnets
### @IDX:APP_ALB
resource "aws_lb" "app_internal_alb" {
  name                       = "app-internal-alb"
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_internal_sg.id]
  subnets                    = [aws_subnet.pri_app_az_1.id, aws_subnet.pri_app_az_2.id]
  enable_deletion_protection = false
  tags                       = { Name = "app-internal-alb" }
}

### @IDX:APP_TG_LISTNER
resource "aws_lb_listener" "app_http" {
  load_balancer_arn = aws_lb.app_internal_alb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}

### @IDX:APP_LAUNCH_TEMPLATE
resource "aws_launch_template" "app_lt" {
  name_prefix   = "app-lt-"
  image_id      = var.app_ami
  instance_type = var.app_instance_type

  vpc_security_group_ids = [aws_security_group.app_tier_sg.id]
  key_name               = aws_key_pair.dipen_keypair.key_name # <-- IMPORTANT

  iam_instance_profile {
    name = aws_iam_instance_profile.ec2_s3_profile.name
  }

  user_data = filebase64("${path.module}/codebase/app_user_data.sh")

  network_interfaces {
    security_groups             = [aws_security_group.app_tier_sg.id]
    associate_public_ip_address = false
  }
  tag_specifications {
    resource_type = "instance"
    tags          = { Name = "app-tier-ec2" }
  }
}

### @IDX:APP_ASG
resource "aws_autoscaling_group" "app_asg" {
  name                      = "app-asg"
  min_size                  = 1
  desired_capacity          = 1
  max_size                  = 4
  vpc_zone_identifier       = [aws_subnet.pri_app_az_1.id, aws_subnet.pri_app_az_2.id]
  health_check_type         = "ELB"
  health_check_grace_period = 120
  target_group_arns         = [aws_lb_target_group.app_tg.arn]

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 90
      instance_warmup        = 60
    }
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
