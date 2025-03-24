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

data "aws_s3_object" "openapi_spec" {
  # If using yaml, must be uploaded as Content-Type plain/text for the body attribute to be available.
  bucket = var.build_artifacts_bucket_name
  key    = var.openapi_spec_object_key
}


module "api_gateway" {
  source = "terraform-aws-modules/apigateway-v2/aws"
  depends_on = [ data.aws_s3_object.openapi_spec ]

  # If using yaml, must be uploaded as Content-Type plain/text for the body attribute to be available.
  body = templatestring(data.aws_s3_object.openapi_spec.body, {
    hem-api-lambda-arn = module.lambda_function.lambda_function_arn
  })


  cors_configuration = {
    allow_headers = ["content-type", "x-amz-date", "authorization", "x-api-key", "x-amz-security-token", "x-amz-user-agent"]
    allow_methods = ["*"]
    allow_origins = ["*"]
  }

  description      = var.description
  fail_on_warnings = false
  name             = var.name

  # Domain Name
  # domain_name           = var.domain_name
  create_domain_records = false
  create_certificate    = false
  create_domain_name    = false

  # Routes & Integrations that are not defined in the OpenAPI spec
  routes = {
    "GET /openapi.json" = {
      integration = local.default_get_integration
    }
    "GET /docs" = {
      integration = local.default_get_integration
    }
    "GET /redoc" = {
      integration = local.default_get_integration
    }
  }

  # Stage
  stage_access_log_settings = {
    create_log_group            = true
    log_group_retention_in_days = 7
    format = jsonencode({
      context = {
        domainName              = "$context.domainName"
        integrationErrorMessage = "$context.integrationErrorMessage"
        protocol                = "$context.protocol"
        requestId               = "$context.requestId"
        requestTime             = "$context.requestTime"
        responseLength          = "$context.responseLength"
        routeKey                = "$context.routeKey"
        stage                   = "$context.stage"
        status                  = "$context.status"
        error = {
          message      = "$context.error.message"
          responseType = "$context.error.responseType"
        }
        identity = {
          sourceIP = "$context.identity.sourceIp"
        }
        integration = {
          error             = "$context.integration.error"
          integrationStatus = "$context.integration.integrationStatus"
        }
      }
    })
  }

  stage_default_route_settings = {
    detailed_metrics_enabled = true
    throttling_burst_limit   = 100
    throttling_rate_limit    = 100
  }

  tags = local.tags
}

module "lambda_function" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "hem-api-function"
  architectures  = ["arm64"]
  timeout        = 300
  create_package = false
  image_uri      = var.lambda_function_image_uri
  package_type   = "Image"
  publish        = true

  cloudwatch_logs_retention_in_days = 7

  # Some problems with this, when publish=false, see https://github.com/terraform-aws-modules/terraform-aws-lambda/issues/36
  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api_gateway.api_execution_arn}/*/*"
    }
  }

  tags = local.tags
}
