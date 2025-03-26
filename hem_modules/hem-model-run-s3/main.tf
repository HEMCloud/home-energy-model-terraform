resource "aws_s3_bucket" "hem_model_runs" {
  bucket = "hem-${var.env_short_string}-model-runs"
}