variable "repository_name" {
  type        = string
  description = "ECR repository name (e.g. ecs-project-dev-threatmod)"
}

variable "scan_on_push" {
  type        = bool
  description = "Enable ECR scan on push"
  default     = true
}

variable "tag_mutability" {
  type        = string
  description = "MUTABLE or IMMUTABLE"
  default     = "MUTABLE"
}

variable "enable_lifecycle_policy" {
  type        = bool
  description = "Whether to attach a basic lifecycle policy"
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "Tags for resources"
  default     = {}
}
