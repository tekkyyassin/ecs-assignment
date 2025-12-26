include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/route53"
}

dependency "alb" {
  config_path = "../alb"
}

inputs = {
  zone_name   = "tekkyyassin.co.uk"
  record_name = "tm.tekkyyassin.co.uk"

  alb_dns_name = dependency.alb.outputs.alb_dns_name
  alb_zone_id  = dependency.alb.outputs.alb_zone_id
}
