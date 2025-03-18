variable "domain_name" {
  description = "Custom domain name to use on API Gateway endpoint"
  type        = string
  default     = "terraform-aws-modules.modules.tf"
}

variable "openapi_spec_yaml_path" {
  description = "OpenAPI Specification YAML file path"
  type        = string
  default     = "./api.yaml"
}

variable "description" {
  description = "Description of the API Gateway"
  type        = string
  default     = "HTTP API Gateway"
}

variable "name" {
  description = "Name of the API Gateway"
  type        = string
}

variable "build_artifacts_bucket_name" {
  description = "Name of the S3 bucket where build artifacts are stored"
  type        = string
}

variable "openapi_spec_object_key" {
  description = "Key of the OpenAPI Specification YAML file in the S3 bucket"
  type        = string
}
