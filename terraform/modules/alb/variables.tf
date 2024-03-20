variable "app_name" {
  type        = string
  description = "App name to prepend to resources name and tags"
}
variable "vpc_id" {
  type        = string
  description = "VPC id"
}
variable "vpc_cidr" {
  type        = string
  description = "VPC cidr"
}
variable "asg_id" {
  type        = string
  description = "Autoscaling group id"
}
variable "subnets" {
  type        = list(string)
  description = "Public subnets"
}
variable "cert_arn" {
  type        = string
  description = "Certificate ARN for HTTPS"
}