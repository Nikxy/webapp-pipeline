output "lb_arn" {
    value = aws_lb.main.arn
}
output "lb_sg" {
    value = aws_security_group.load_balancer.arn
}
output "dns_name" {
    value = aws_lb.main.dns_name
}