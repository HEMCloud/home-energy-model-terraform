data "aws_s3_object" "openapi_spec" {
  # If using yaml, must be uploaded as Content-Type plain/text for the body attribute to be available.
  bucket = var.build_artifacts_bucket_name
  key    = var.openapi_spec_object_key
}