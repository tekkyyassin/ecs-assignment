include "root" {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../../../modules/github-oidc"
}

inputs = {
  repo   = "tekkyyassin/ecs-assignment"
  branch = "main"

  role_name         = "gha-terragrunt-ecs-assignment"
  state_bucket_name = "tg-100594274847-ecs-threatmod-tfstate-eu-west-2"
  lock_table_name   = "tg-100594274847-ecs-threatmod-locks"
}
