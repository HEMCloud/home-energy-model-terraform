module "lambda_function_container_image" {
  source = "terraform-aws-modules/lambda/aws"
  function_name = "hem-lambda-function"
  architectures = ["arm64"]
  timeout = 300
  create_package = false
  image_uri    = "317467111462.dkr.ecr.eu-west-2.amazonaws.com/hem-lambda-image-repository:hemlambdafunction-d309c0d00ba6-python3.9-hem"
  package_type = "Image"
}