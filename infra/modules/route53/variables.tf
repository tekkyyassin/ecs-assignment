variable "zone_name" {
  description = "Route53 hosted zone name to create (e.g. tm.tekkyyassin.co.uk)"
  type        = string
}

variable "record_name" {
  description = "DNS record to create in the zone. Leave empty to create the zone-apex record."
  type        = string
  default     = ""
}

variable "alb_dns_name" {
  description = "ALB DNS name (e.g. xxx.eu-west-2.elb.amazonaws.com)"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB hosted zone id (from aws_lb.zone_id output)"
  type        = string
}
