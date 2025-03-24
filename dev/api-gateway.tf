module "complete-api-gateway" {
  source                           = "./complete-http"
  description                      = "Main HTTP API Gateway for HEM Cloud"
  name                             = "hem-cloud-api-gateway"
  build_artifacts_bucket_name      = "hem-build-artifacts"
  openapi_spec_object_key          = "openapi.json"
  lambda_function_image_uri        = "317467111462.dkr.ecr.eu-west-2.amazonaws.com/hem-lambda-image-repository:hemapifunction-1a83e3529688-python3.13-hem-api"
  hem_model_runs_bucket_name       = aws_s3_bucket.hem_model_runs.id
  hem_model_runs_bucket_arn        = aws_s3_bucket.hem_model_runs.arn
  hem_model_runs_dynamo_table_arn  = module.dynamodb_table.dynamodb_table_arn
  hem_model_runs_dynamo_table_name = module.dynamodb_table.dynamodb_table_id
}
