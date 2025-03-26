variable "build_artifacts_bucket_name" {
  description = "The name of the S3 bucket where build artifacts are stored"
  type        = string
}

variable "dynamo_stream_lambda_s3_object_key" {
  description = "The S3 object key of the Dynamo Stream Orchestrator Lambda zip in the build artifacts bucket"
  type        = string
}

variable "step_function_state_machine_arn" {
  description = "The ARN of the Step Function state machine"
  type        = string
}

variable "dynamo_stream_arn" {
  description = "The ARN of the DynamoDB stream"
  type        = string
}

