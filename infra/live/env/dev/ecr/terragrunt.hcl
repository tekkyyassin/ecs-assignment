include "root" {
  path = find_in_parent_folders("root.hcl")
}

locals {
  env_cfg = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  project = local.env_cfg.locals.project
  env     = local.env_cfg.locals.env
  region  = local.env_cfg.locals.region
  tags    = local.env_cfg.locals.common_tags
}

terraform {
  source = "../../../../modules/ecr"
}

inputs = {
  repository_name = "${local.project}-${local.env}-threatmod"
  tags            = local.tags
}
