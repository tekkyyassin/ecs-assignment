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
  project_name          = local.project
  vpc_cidr              = "10.0.0.0/16"
  azs                   = ["eu-west-2a", "eu-west-2b"]
  public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]

  tags = local.common_tags
}
