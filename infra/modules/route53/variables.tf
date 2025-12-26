variable "zone_name" {
  description = "Route53 hosted zone name (e.g. tekkyyassin.co.uk)"
  type        = string
}

variable "record_name" {
  description = "Full DNS record name to create (e.g. tm.tekkyyassin.co.uk)"
  type        = string
}

variable "alb_dns_name" {
  description = "ALB DNS name (e.g. xxx.eu-west-2.elb.amazonaws.com)"
  type        = string
}

variable "alb_zone_id" {
  description = "ALB hosted zone id (from aws_lb.zone_id output)"
  type        = string
}
