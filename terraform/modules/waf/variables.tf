variable "app_name" {
  type        = string
  description = "App name to prepend to resources name and tags"
}

variable "association_arn" {
  type        = string
  description = "The arn of the resource to associate to"
}