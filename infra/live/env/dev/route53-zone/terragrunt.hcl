include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("env.hcl")
}

terraform {
  source = "../../../../modules/route53-zone"
}

inputs = {
  zone_name = "tm.tekkyyassin.co.uk"
}
