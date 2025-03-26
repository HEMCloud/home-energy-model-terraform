module "hem-http-api-gateway" {
  source                           = "../hem_modules/hem-api-gateway"
  build_artifacts_bucket_name      = var.build_artifacts_bucket_name
  openapi_spec_object_key          = "openapi.json"
  api_lambda_image_uri             = var.api_lambda_image_uri
  hem_model_runs_bucket_name       = module.hem-model-run-s3.bucket_name
  hem_model_runs_bucket_arn        = module.hem-model-run-s3.bucket_arn
  hem_model_runs_dynamo_table_arn  = module.hem-model-run-dynamo.hem-model-run-dynamo-table-arn
  hem_model_runs_dynamo_table_name = module.hem-model-run-dynamo.hem-model-run-dynamo-table-name
}
