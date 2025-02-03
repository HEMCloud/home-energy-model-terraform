variable "dev_account_id" {
  description = "The development AWS account ID"
  type        = string
  default     = "864981718509"
}

variable "mgt_account_id" {
  description = "The management AWS account ID"
  type        = string
  default     = "317467111462"
}

variable "assume_role_name" {
  description = "The name of the role to assume"
  type        = string
  default     = "TerraformAdmin"
}
