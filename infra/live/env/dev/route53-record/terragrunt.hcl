include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

dependency "route53_zone" {
  config_path = "../route53-zone"

  mock_outputs = {
    zone_id = "Z0000000000000"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

dependency "alb" {
  config_path = "../alb"

  mock_outputs = {
    alb_dns_name = "mock-alb-123.eu-west-2.elb.amazonaws.com"
    alb_zone_id  = "Z32O12XQLNTSW2"
  }

  mock_outputs_allowed_terraform_commands = ["plan", "validate", "destroy"]
  mock_outputs_merge_strategy_with_state  = "shallow"
}

terraform {
  source = "../../../../modules/route53-record"
}

inputs = {
  zone_id     = dependency.route53_zone.outputs.zone_id
  zone_name   = "tm.tekkyyassin.co.uk"
  record_name = "" # apex record in the tm zone

  alb_dns_name = dependency.alb.outputs.alb_dns_name
  alb_zone_id  = dependency.alb.outputs.alb_zone_id
}
