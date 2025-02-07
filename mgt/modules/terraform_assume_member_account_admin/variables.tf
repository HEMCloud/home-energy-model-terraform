variable "hcp_organization" {
  description = "The HCP Terraform organization name"
  type        = string
  default     = "hem-cloud"
}

variable "hcp_project" {
  description = "The HCP Terraform project name"
  type        = string
  default     = "Home-Energy-Model-Cloud"
}

variable "hcp_workspace" {
  description = "The HCP Terraform workspace name"
  type        = string
}
