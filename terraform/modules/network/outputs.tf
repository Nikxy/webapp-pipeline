output vpc_id {
  value       = aws_vpc.main.id
  description = "VPC id"
}
output public_subnets {
  value       = aws_subnet.public.*.id
  description = "List of public subnets ids"
}
output private_subnets {
  value       = aws_subnet.private.*.id
  description = "List of private subnets ids"
}
