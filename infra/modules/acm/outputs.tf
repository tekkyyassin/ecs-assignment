output "certificate_arn" {
  description = "ARN of the validated ACM certificate (waits until ISSUED)"
  value       = aws_acm_certificate_validation.this.certificate_arn
}

output "domain_validation_records" {
  description = "DNS validation records ACM requires (these are created in Route53 by this module)"
  value = [
    for dvo in aws_acm_certificate.this.domain_validation_options : {
      domain = dvo.domain_name
      name   = dvo.resource_record_name
      type   = dvo.resource_record_type
      value  = dvo.resource_record_value
    }
  ]
}
