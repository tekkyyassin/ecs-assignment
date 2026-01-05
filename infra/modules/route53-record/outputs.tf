output "record_fqdn" {
  value       = aws_route53_record.tm.fqdn
  description = "Final record created"
}
