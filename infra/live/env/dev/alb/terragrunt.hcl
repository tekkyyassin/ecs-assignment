include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "../../../../modules/alb"
}

locals {
  # Pull env-level locals (env/dev/env.hcl)
  env_cfg = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  env     = local.env_cfg.locals.env
  project = local.env_cfg.locals.project
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id            = "vpc-00000000"
    public_subnet_ids = ["subnet-00000000", "subnet-00000001"]
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "acm" {
  config_path = "../acm"

  mock_outputs = {
    certificate_arn = "arn:aws:acm:eu-west-2:000000000000:certificate/mock"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
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
