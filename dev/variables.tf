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
