variable "app_name" {
  type        = string
  description = "App name to prepend to resources name and tags"
}

variable "aws_availability_zones" {
  type        = list(string)
  description = "AWS AZs to use"
}

variable "vpc_cidr" {
  type        = string
  description = "An CIDR for the VPC"
}