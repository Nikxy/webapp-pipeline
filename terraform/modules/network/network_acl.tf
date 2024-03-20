resource "aws_network_acl" "private" {
  vpc_id = aws_vpc.main.id
  subnet_ids = aws_subnet.private.*.id

  # Allow HTTPS OUT
  egress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }
  # Allow returned traffic from web
  ingress {
    protocol   = "tcp"
    rule_no    = 100
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 32768
    to_port    = 61000
  }
  
  # Allow traffic in from ALB
  ingress {
    protocol   = "tcp"
    rule_no    = 99
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 8000
    to_port    = 8000
  }
  # Allow traffic out to ALB
  egress {
    protocol   = "tcp"
    rule_no    = 99
    action     = "allow"
    cidr_block = aws_vpc.main.cidr_block
    from_port  = 1024
    to_port    = 65535
  }
  
  tags = {
    Name = "${var.app_name}-private-acl"
    Project = "webapp"
  }
}
