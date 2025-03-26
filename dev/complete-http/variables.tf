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
  description = <<-EOF
    Key of the OpenAPI Specification YAML file in the S3 bucket. 
    If file is yaml format, it must be uploaded with System defined metadata 
    Content-Type of text/plain.
  EOF
  type        = string
}

variable "api_lambda_image_uri" {
  description = "URI of the Lambda function container image"
  type        = string
}

variable "hem_model_runs_bucket_name" {
  description = "Name of the S3 bucket where model run input and output json is stored"
  type        = string
}

variable "hem_model_runs_bucket_arn" {
  description = "ARN of the S3 bucket where model run input and output json is stored"
  type        = string
}

variable "hem_model_runs_dynamo_table_name" {
  description = "Name of the DynamoDB table where model run evaluation status is stored"
  type        = string
}

variable "hem_model_runs_dynamo_table_arn" {
  description = "ARN of the DynamoDB table where model run evaluation status is stored"
  type        = string
}
