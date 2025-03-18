module "complete-api-gateway" {
    source = "./complete-http"
    description = "Main HTTP API Gateway for HEM Cloud"
    name = "hem-cloud-api-gateway"
    build_artifacts_bucket_name = "hem-build-artifacts"
    openapi_spec_object_key = "api.yaml"
}