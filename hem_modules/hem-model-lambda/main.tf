module "hem-model-lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "hem-model-lambda-function"
  architectures  = ["arm64"]
  timeout        = 300
  create_package = false
  image_uri      = var.hem_lambda_image_uri
  package_type   = "Image"
}