locals {
  tags = {
    Example    = var.name
    GithubRepo = "terraform-aws-apigateway-v2"
    GithubOrg  = "terraform-aws-modules"
  }
  default_get_integration = {
    uri                    = module.lambda_function.lambda_function_arn
    payload_format_version = "2.0"
    http_method            = "GET"
    connection_type        = "INTERNET"
    type                   = "AWS_PROXY"
  }
}