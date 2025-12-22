locals {
  region       = "eu-west-2"
  state_bucket = "tg-100594274847-ecs-threatmod-tfstate-eu-west-2"
  lock_table   = "tg-100594274847-ecs-threatmod-locks"
}

remote_state {
  backend = "s3"
  config = {
    bucket         = local.state_bucket
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = local.region
    encrypt        = true
    dynamodb_table = local.lock_table
  }
}

# Generate provider.tf into every stack folder under live/
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region = "${local.region}"
}
EOF
}
