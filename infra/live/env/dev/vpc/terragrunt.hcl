include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "../../../../modules/vpc"
}

inputs = {
  vpc_cidr              = "10.0.0.0/16"
  azs                   = ["eu-west-2a", "eu-west-2b"]
  public_subnets_cidrs  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets_cidrs = ["10.0.101.0/24", "10.0.102.0/24"]
}
