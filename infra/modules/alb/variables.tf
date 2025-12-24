variable "project_name" {
  type        = string
  description = "Project prefix for tagging/naming"
}

variable "env" {
  type        = string
  description = "Environment name (e.g. dev)"
}

variable "alb_name" {
  type        = string
  description = "ALB name (must be unique in region/account)"
}

variable "vpc_id" {
  type        = string
  description = "VPC id for ALB + target group"
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "Public subnet ids for ALB (min 2 for HA)"
}

variable "certificate_arn" {
  type        = string
  description = "ACM certificate ARN for HTTPS listener"
}

variable "target_port" {
  type        = number
  description = "Port your service listens on (nginx=80)"
  default     = 80
}

variable "health_check_path" {
  type        = string
  description = "Health check path (e.g. /health)"
  default     = "/health"
}

variable "tags" {
  type        = map(string)
  description = "Extra tags"
  default     = {}
}
