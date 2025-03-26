# Default vars
# ------------------------------

variable "dev_account_id" {
  description = "The development AWS account ID"
  type        = string
  default     = "864981718509"
}

variable "build_artifacts_bucket_name" {
  description = "The name of the S3 bucket where build artifacts are stored"
  type        = string
  default     = "hem-build-artifacts"
}

variable "env_short_string" {
  description = "The short string representing the environment"
  type        = string
  default     = "dev"
}

# Non-default vars, must be set
# ------------------------------

variable "api_lambda_image_uri" {
  description = "The URI of the Docker image for the Lambda function used for API Gateway Integrations"
  type        = string
}

variable "dynamo_stream_lambda_s3_object_key" {
  description = "The S3 object key of the Dynamo Stream Orchestrator Lambda zip in the build artifacts bucket"
  type        = string
}
