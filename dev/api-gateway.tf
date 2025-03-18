module "complete-api-gateway" {
    source = "./complete-http"
    description = "Main HTTP API Gateway for HEM Cloud"
    name = "hem-cloud-api-gateway"
    build_artifacts_bucket_name = module.s3_bucket.s3_bucket_id
    openapi_spec_object_key = module.s3_bucket.s3_bucket_id
}