locals {
  env     = "dev"
  region  = "eu-west-2"
  project = "ecs-project"

  common_tags = {
    Project   = local.project
    Env       = local.env
    ManagedBy = "terragrunt"
  }
}

inputs = {
  project_name = local.project
  tags         = local.common_tags
}
