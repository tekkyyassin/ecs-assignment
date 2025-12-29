include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

dependency "alb" {
  config_path = "../alb"
}

terraform {
  source = "../../../../modules/route53"
}

inputs = {
  zone_name    = "tm.tekkyyassin.co.uk"
  record_name  = "" # apex record in the tm zone
  alb_dns_name = dependency.alb.outputs.alb_dns_name
  alb_zone_id  = dependency.alb.outputs.alb_zone_id
}
