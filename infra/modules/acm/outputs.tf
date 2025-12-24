output "certificate_arn" {
  description = "ARN of the ACM certificate"
  value       = aws_acm_certificate.this.arn
}

output "domain_validation_records" {
  description = "DNS records to create in Cloudflare for validation"
  value = [
    for dvo in aws_acm_certificate.this.domain_validation_options : {
      domain = dvo.domain_name
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  ]
}
