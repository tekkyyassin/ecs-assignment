include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

locals {
  #read the file you actually use now
  env_cfg = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Local default for manual testing; CI will override IMAGE_TAG (e.g. short SHA)
  image_tag = get_env("IMAGE_TAG", "1.0.2")

  #keep repo_url in locals, but source it from an env var (locals-safe)
  repo_url_override = trimspace(get_env("ECR_REPO_URL", ""))
}

terraform {
  source = "../../../../modules/ecs"
}

dependency "vpc" {
  config_path = "../vpc"

  mock_outputs = {
    vpc_id             = "vpc-00000000"
    private_subnet_ids = ["subnet-00000002", "subnet-00000003"]
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    alb_security_group_id = "sg-00000000"
    target_group_arn      = "arn:aws:elasticloadbalancing:eu-west-2:000000000000:targetgroup/mock/1234567890abcdef"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "ecr" {
  config_path = "../ecr"

  mock_outputs = {
    repository_url = "000000000000.dkr.ecr.eu-west-2.amazonaws.com/mock-repo"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}


inputs = {
  project_name = local.env_cfg.locals.project
  env          = local.env_cfg.locals.env
  tags         = local.env_cfg.locals.common_tags

  vpc_id             = dependency.vpc.outputs.vpc_id
  private_subnet_ids = dependency.vpc.outputs.private_subnet_ids

  alb_security_group_id = dependency.alb.outputs.alb_security_group_id
  target_group_arn      = dependency.alb.outputs.target_group_arn

  #use override if provided, otherwise fall back to dependency output (allowed in inputs)
  container_image = "${local.repo_url_override != "" ? local.repo_url_override : dependency.ecr.outputs.repository_url}:${local.image_tag}"

  container_port    = 80
  desired_count     = 1
  cpu               = 256
  memory            = 512
  health_check_path = "/health"
}
