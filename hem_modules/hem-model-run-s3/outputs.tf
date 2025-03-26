output "bucket_name" {
  value = aws_s3_bucket.hem_model_runs.id
}

output "bucket_arn" {
  value = aws_s3_bucket.hem_model_runs.arn
}
