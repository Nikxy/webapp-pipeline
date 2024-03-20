module "network" {
  source   = "../modules/network"
  app_name = var.app_name
  vpc_cidr = var.vpc_cidr
  aws_availability_zones = var.aws_availability_zones
}

module "acm" {
  source = "../modules/acm-certificate"
  domain = var.app_domain
}

module "alb" {
  source   = "../modules/alb"
  app_name = var.app_name
  vpc_cidr = var.vpc_cidr
  vpc_id   = module.network.vpc_id
  asg_id   = module.compute.asg_id
  subnets  = module.network.public_subnets
  cert_arn = module.acm.cert_arn
}

module "waf" {
  source          = "../modules/waf"
  app_name        = var.app_name
  association_arn = module.alb.lb_arn
}

module "compute" {
  source     = "../modules/compute"
  app_name   = var.app_name
  vpc_cidr   = var.vpc_cidr
  vpc_id     = module.network.vpc_id
  subnets    = module.network.private_subnets
  ingress_sg = module.alb.lb_sg
}
