output "hem-model-run-dynamo-table-arn" {
  description = "The ARN of the HEM Model Run DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_arn
}

output "hem-model-run-dynamo-table-name" {
  description = "The name of the HEM Model Run DynamoDB table"
  value       = module.dynamodb_table.dynamodb_table_id
}

output "hem-model-run-dynamo-stream-arn" {
  description = "The ARN of the HEM Model Run DynamoDB stream"
  value       = module.dynamodb_table.dynamodb_table_stream_arn
}
