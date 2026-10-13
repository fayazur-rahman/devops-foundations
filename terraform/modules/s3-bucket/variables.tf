variable "name" {
  description = "The name of the S3 bucket."
  type        = string

  validation {
    condition     = can(regex("^[a-z0-9.-]{3,63}$", var.name))
    error_message = "The bucket name must be between 3 and 63 characters, and can only contain lowercase letters, numbers, dots, and hyphens."
  }
}

variable "tags" {
  description = "A map of tags to assign to the bucket."
  type        = map(string)
  default     = {}
}
