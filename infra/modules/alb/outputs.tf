output "alb_arn" {
  value       = aws_lb.this.arn
  description = "ALB ARN"
}

output "alb_dns_name" {
  value       = aws_lb.this.dns_name
  description = "ALB DNS name (use for DNS record)"
}

output "alb_zone_id" {
  value       = aws_lb.this.zone_id
  description = "ALB zone id (needed for Route53 alias records)"
}

output "alb_security_group_id" {
  value       = aws_security_group.alb.id
  description = "Security group id for the ALB"
}

output "target_group_arn" {
  value       = aws_lb_target_group.app.arn
  description = "Target group ARN (ECS service will register tasks here)"
}
