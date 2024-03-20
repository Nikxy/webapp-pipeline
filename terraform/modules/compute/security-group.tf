resource "aws_security_group" "ec2" {
  name        = "${var.app_name}-ec2-sg"
  description = "Controls access to the ALB"
  vpc_id      = var.vpc_id

  # Allow traffic to app
  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }
  # Allow traffic out for API, YUM, Docker
  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
     Project = "webapp"
  }
  depends_on = [var.ingress_sg]
}
