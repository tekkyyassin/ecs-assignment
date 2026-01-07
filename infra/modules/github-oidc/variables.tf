variable "repo" {
  description = "GitHub repo in ORG/REPO format"
  type        = string
}

variable "branch" {
  description = "Branch allowed to deploy (e.g. main)"
  type        = string
  default     = "main"
}

variable "role_name" {
  description = "IAM role name to create"
  type        = string
  default     = "gha-terragrunt"
}

variable "state_bucket_name" {
  description = "S3 bucket name used for Terraform remote state"
  type        = string
}

variable "lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking"
  type        = string
}
