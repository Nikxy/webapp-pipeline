resource "aws_subnet" "public" {
  count = length(var.aws_availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = local.cidr_blocks[count.index]
  availability_zone = var.aws_availability_zones[count.index]
  tags = {
    Name = "${var.app_name}-public-${count.index}"
    

  }
}

resource "aws_route_table_association" "public_main" {
  count = length(var.aws_availability_zones)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_subnet" "private" {
  count = length(var.aws_availability_zones)
  vpc_id = aws_vpc.main.id
  cidr_block = local.cidr_blocks[length(var.aws_availability_zones) + count.index]
  availability_zone = var.aws_availability_zones[count.index]
  tags = {
    Name = "${var.app_name}-private-${count.index}"
  }
}

resource "aws_route_table_association" "private_main" {
  count = length(var.aws_availability_zones)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.local[count.index].id
}
