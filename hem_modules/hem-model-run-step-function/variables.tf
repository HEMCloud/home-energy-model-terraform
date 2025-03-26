variable "hem_model_lambda_arn" {
  description = "The ARN of the HEM Model Lambda"
  type        = string
}

variable "hem_model_run_dynamo_table_name" {
  description = "The name of the HEM Model Run DynamoDB table"
  type        = string
}

variable "hem_model_run_dynamo_table_arn" {
  description = "The ARN of the HEM Model Run DynamoDB table"
  type        = string
}

variable "hem_model_run_s3_bucket_name" {
  description = "The name of the HEM Model Run S3 bucket"
  type        = string
}

variable "hem_model_run_s3_bucket_arn" {
  description = "The ARN of the HEM Model Run S3 bucket"
  type        = string
}
