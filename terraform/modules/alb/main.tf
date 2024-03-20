# Load Balancer
resource "aws_lb" "main" {
  name               = "${var.app_name}-alb"
  load_balancer_type = "application"
  internal           = false
  security_groups    = [aws_security_group.load_balancer.id]
  subnets            = var.subnets
  tags = {
     Project = "webapp"
  }
}

# Target group
resource "aws_alb_target_group" "main" {
  name     = "${var.app_name}-tg"
  port     = 8000
  protocol = "HTTP"
  vpc_id   = var.vpc_id
  tags = {
     Project = "webapp"
  }
}

# Attach Load Balancer to ASG
resource "aws_autoscaling_attachment" "asg_attachment_bar" {
  autoscaling_group_name = var.asg_id
  lb_target_group_arn    = aws_alb_target_group.main.arn
}

# Listener
resource "aws_alb_listener" "main" {
  load_balancer_arn = aws_lb.main.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.cert_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.main.arn
  }
  tags = {
     Project = "webapp"
  }
}
