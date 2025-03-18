module "complete-api-gateway" {
    source = "./complete-http"
    description = "Main HTTP API Gateway for HEM Cloud"
    name = "hem-cloud-api-gateway"
}