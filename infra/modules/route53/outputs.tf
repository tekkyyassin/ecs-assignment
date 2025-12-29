output "zone_id" {
  value       = aws_route53_zone.this.zone_id
  description = "Route53 hosted zone id"
}

output "name_servers" {
  value       = aws_route53_zone.this.name_servers
  description = "Nameservers for delegating this subdomain from Cloudflare"
}

output "record_fqdn" {
  value       = aws_route53_record.tm.fqdn
  description = "Final record created"
}
