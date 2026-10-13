variable "region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "us-east-1"
}

variable "project" {
  description = "The project name to use for resource naming."
  type        = string
  default     = "devops-foundations"
}

variable "environment" {
  description = "Deployment environment (e.g., dev, staging, prod)."
  type        = string

  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "name_suffix" {
  description = "A suffix to append to resource names for uniqueness."
  type        = string
}

variable "extra_tags" {
  description = "Additional tags to apply to resources."
  type        = map(string)
  default     = {}
}