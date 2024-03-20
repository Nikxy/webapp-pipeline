# Main VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = "${var.app_name}-main-vpc"
    Project = "webapp"
  }
}
# Internet gateway for ALB
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.app_name}-main-igw"
    Project = "webapp"
  }
}

locals {
  cidr_blocks = cidrsubnets(aws_vpc.main.cidr_block,4,4,4,4,4,4,4,4,4,4,4,4,4)
}

# Elastic ips for NAT Gateways
resource "aws_eip" "nat_gateway" {
  count = length(var.aws_availability_zones)
  tags = {
    Project = "webapp"
  }
}

# Nat Gateways for Internet access, multiple for improved resiliency
resource "aws_nat_gateway" "nat_gw" {
  count = length(var.aws_availability_zones)
  allocation_id = aws_eip.nat_gateway[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = {
    Name = "${var.app_name}-nat-gw-${count.index}"
    Project = "webapp"
  }
}

