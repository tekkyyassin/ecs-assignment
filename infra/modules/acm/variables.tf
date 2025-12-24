variable "domain_name" {
  description = "Primary domain name for the ACM cert (e.g. tekkyyassin.co.uk)"
  type        = string
}

variable "subject_alternative_names" {
  description = "Optional SANs (e.g. www.tekkyyassin.co.uk)"
  type        = list(string)
  default     = []
}

variable "validation_method" {
  description = "DNS or EMAIL (DNS recommended)"
  type        = string
  default     = "DNS"
}

variable "tags" {
  description = "Tags to apply"
  type        = map(string)
  default     = {}
}
