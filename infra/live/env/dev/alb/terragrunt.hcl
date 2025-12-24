include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/alb"
}

locals {
  # Pull env-level locals (env/dev/terragrunt.hcl)
  env_cfg = read_terragrunt_config(find_in_parent_folders("terragrunt.hcl"))

  env     = local.env_cfg.locals.env
  project = local.env_cfg.locals.project
}

dependency "vpc" {
  config_path = "../vpc"
}

dependency "acm" {
  config_path = "../acm"
}

inputs = {
  project_name = local.project
  env          = local.env

  vpc_id            = dependency.vpc.outputs.vpc_id
  public_subnet_ids = dependency.vpc.outputs.public_subnet_ids

  certificate_arn = dependency.acm.outputs.certificate_arn

  alb_name          = "${local.project}-${local.env}-alb"
  health_check_path = "/health"
  target_port       = 80
}
