include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

locals {
  env_cfg = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))
}

terraform {
  source = "../../../../modules/ecs"
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "alb" {
  config_path = "../alb"
}

dependency "ecr" {
  config_path = "../ecr"
}

inputs = {
  project_name = local.env_cfg.locals.project
  env          = local.env_cfg.locals.env
  tags         = local.env_cfg.locals.common_tags

  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids

  alb_security_group_id = dependency.alb.outputs.alb_security_group_id
  target_group_arn      = dependency.alb.outputs.target_group_arn

  container_image   = "${dependency.ecr.outputs.repository_url}:1.0.0"
  container_port    = 80
  desired_count     = 1
  cpu               = 256
  memory            = 512
  health_check_path = "/health"
}
