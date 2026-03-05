module "network" {
  source             = "./modules/network"
  vpc_cidr           = var.vpc_cidr
  availability_zones = var.availability_zones
  tags               = var.additional_tags
  environment        = terraform.workspace
}

module "security" {
  source   = "./modules/security"
  vpc_id   = module.network.vpc_id
  app_port = var.app_port
  tags     = var.additional_tags
}

module "iam" {
  source = "./modules/iam"
}

module "waf" {
  source = "./modules/waf"
  tags   = var.additional_tags
}

module "alb" {
  source            = "./modules/alb"
  enable_waf        = var.enable_waf
  vpc_id            = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_sg_id         = module.security.alb_sg_id
  app_port          = var.app_port
  waf_acl_arn       = module.waf.waf_acl_arn
  tags              = var.additional_tags
}

module "compute" {
  source             = "./modules/compute"
  instance_type      = var.instance_type
  instance_profile   = module.iam.instance_profile
  private_subnet_ids = module.network.private_subnet_ids
  target_group_arn   = module.alb.target_group_arn
  desired_capacity   = var.desired_capacity
  min_size           = var.min_size
  max_size           = var.max_size
  tags               = var.additional_tags
}

module "observability" {
  source         = "./modules/observability"
  asg_name       = module.compute.asg_name
  alb_arn_suffix = module.alb.alb_arn_suffix
  email_endpoint = var.email_endpoint
  tags           = var.additional_tags
}