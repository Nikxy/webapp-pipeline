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
variable "subnets" {
  type        = list(string)
  description = "Subnets used"
}
variable "ingress_sg" {
  type        = string
  description = "Ingress security group id for an sg rule"
}
variable "image_url" {
  type        = string
  description = "The url of the image to use"
}