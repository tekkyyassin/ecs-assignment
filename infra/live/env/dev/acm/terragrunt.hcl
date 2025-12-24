include "root" {
  path = find_in_parent_folders("root.hcl")
}

include "env" {
  path = find_in_parent_folders("terragrunt.hcl")
}

terraform {
  source = "../../../../modules/acm"
}

inputs = {
  domain_name               = "tekkyyassin.co.uk"
  subject_alternative_names = ["www.tekkyyassin.co.uk"]
  validation_method         = "DNS"
}
