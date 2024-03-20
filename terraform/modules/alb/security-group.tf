resource "aws_security_group" "load_balancer" {
  name        = "${var.app_name}-lb"
  description = "Controls access to the ALB"
  vpc_id      = var.vpc_id

  # Allow traffic in
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Allow traffic out to the app deployment
  egress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  tags = {
     Project = "webapp"
  }
}