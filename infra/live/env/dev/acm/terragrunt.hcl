include "root" { path = find_in_parent_folders("root.hcl") }
include "env" { path = find_in_parent_folders("env.hcl") }

dependency "route53_zone" {
  config_path = "../route53-zone"
}

terraform {
  source = "../../../../modules/acm"
}

inputs = {
  domain_name               = "tm.tekkyyassin.co.uk"
  subject_alternative_names = []
  validation_method         = "DNS"

  route53_zone_id = dependency.route53_zone.outputs.zone_id
}
