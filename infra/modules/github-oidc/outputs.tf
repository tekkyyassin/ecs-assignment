output "role_arn" {
  value       = aws_iam_role.this.arn
  description = "Role ARN to use in GitHub Actions"
}

output "oidc_provider_arn" {
  value       = aws_iam_openid_connect_provider.github.arn
  description = "GitHub OIDC provider ARN"
}
