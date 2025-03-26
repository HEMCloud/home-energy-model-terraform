module "hem-model-lambda" {
  source = "../hem_modules/hem-model-lambda"
  hem_lambda_image_uri = var.hem_lambda_image_uri
}

