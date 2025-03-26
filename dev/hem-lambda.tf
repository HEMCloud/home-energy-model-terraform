module "lambda_function_container_image" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "hem-lambda-function"
  architectures  = ["arm64"]
  timeout        = 300
  create_package = false
  image_uri      = var.hem_lambda_image_uri
  package_type   = "Image"
}

