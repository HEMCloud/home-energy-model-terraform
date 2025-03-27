module "hem-model-run-s3" {
  source           = "../hem_modules/hem-model-run-s3"
  env_short_string = var.env_short_string
}

resource "aws_s3_bucket" "test_bucket" {
  bucket = "i-am-a-unique-bucket-name-123987"
}
