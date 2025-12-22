variable "project_name" {
  description = "Project/name prefix used for tagging and resource naming (e.g. threatmod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC (e.g. 10.0.0.0/16)"
  type        = string
}

variable "azs" {
  description = "Availability Zones to use (2 recommended for HA), e.g. [\"eu-west-2a\",\"eu-west-2b\"]"
  type        = list(string)

  validation {
    condition     = length(var.azs) >= 2
    error_message = "Provide at least 2 AZs for high availability."
  }
}

variable "public_subnets_cidrs" {
  description = "CIDR blocks for public subnets (one per AZ), e.g. [\"10.0.1.0/24\",\"10.0.2.0/24\"]"
  type        = list(string)

  validation {
    condition     = length(var.public_subnets_cidrs) == length(var.azs)
    error_message = "public_subnets_cidrs must be the same length as azs (one public subnet per AZ)."
  }
}

variable "private_subnets_cidrs" {
  description = "CIDR blocks for private subnets (one per AZ), e.g. [\"10.0.101.0/24\",\"10.0.102.0/24\"]"
  type        = list(string)

  validation {
    condition     = length(var.private_subnets_cidrs) == length(var.azs)
    error_message = "private_subnets_cidrs must be the same length as azs (one private subnet per AZ)."
  }
}

variable "enable_dns_support" {
  description = "Enable DNS support in the VPC (recommended true)"
  type        = bool
  default     = true
}

variable "enable_dns_hostnames" {
  description = "Enable DNS hostnames in the VPC (recommended true)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Extra tags to apply to resources"
  type        = map(string)
  default     = {}
}
