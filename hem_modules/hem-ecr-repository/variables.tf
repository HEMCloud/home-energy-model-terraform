variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "image_tag_mutability" {
  description = "The tag mutability setting for the repository"
  type        = string
  default     = "IMMUTABLE"
}

variable "account_ids" {
  description = "List of AWS account IDs that need access to the repository"
  type        = list(string)
}

variable "region" {
  description = "AWS region"
  type        = string
}
