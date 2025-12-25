variable "project_name" {
  description = "Name/prefix used for resource naming (e.g. ecs-project)"
  type        = string
}

variable "env" {
  description = "Environment name (e.g. dev)"
  type        = string
}

variable "tags" {
  description = "Extra tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID where ECS will run"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnet IDs for ECS tasks (Fargate)"
  type        = list(string)
}

variable "alb_security_group_id" {
  description = "Security group ID of the ALB"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN to register ECS tasks into"
  type        = string
}

variable "container_image" {
  description = "Full image URI incl tag (ECR), e.g. <acct>.dkr.ecr.../repo:sha"
  type        = string
}

variable "container_port" {
  description = "App container port"
  type        = number
  default     = 80
}

variable "desired_count" {
  description = "Number of tasks to run"
  type        = number
  default     = 1
}

variable "cpu" {
  description = "Fargate CPU units (256, 512, 1024...)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Fargate memory (MiB) (512, 1024, 2048...)"
  type        = number
  default     = 512
}

variable "health_check_path" {
  description = "Health check path for the app"
  type        = string
  default     = "/health"
}
