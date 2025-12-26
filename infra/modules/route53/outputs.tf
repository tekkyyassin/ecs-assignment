output "zone_id" {
  description = "Hosted zone ID"
  value       = data.aws_route53_zone.this.zone_id
}

output "record_fqdn" {
  description = "FQDN of the created record"
  value       = aws_route53_record.tm.fqdn
}
