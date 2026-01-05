locals {
  record_fqdn = var.record_name != "" ? var.record_name : var.zone_name
}

resource "aws_route53_record" "tm" {
  zone_id = var.zone_id
  name    = local.record_fqdn
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}
