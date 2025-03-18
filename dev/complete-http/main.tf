locals {
  tags = {
    Example    = var.name
    GithubRepo = "terraform-aws-apigateway-v2"
    GithubOrg  = "terraform-aws-modules"
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

  # Authorizer(s)
  # authorizers = {
  #   cognito = {
  #     authorizer_type  = "JWT"
  #     identity_sources = ["$request.header.Authorization"]
  #     name             = "cognito"
  #     jwt_configuration = {
  #       audience = ["d6a38afd-45d6-4874-d1aa-3c5c558aqcc2"]
  #       issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
  #     }
  #   }
  # }

  # Domain Name
  # domain_name           = var.domain_name
  create_domain_records = false
  create_certificate    = false
  create_domain_name    = false

  # mutual_tls_authentication = {
  #   truststore_uri     = "s3://${module.s3_bucket.s3_bucket_id}/${aws_s3_object.this.id}"
  #   truststore_version = aws_s3_object.this.version_id
  # }

  # Routes & Integration(s)
  # routes = {
  #   "ANY /" = {
  #     detailed_metrics_enabled = false

  #     integration = {
  #       uri                    = module.lambda_function.lambda_function_arn
  #       payload_format_version = "2.0"
  #       timeout_milliseconds   = 12000
  #     }
  #   }

  #   "GET /some-route" = {
  #     authorization_type       = "JWT"
  #     authorizer_id            = aws_apigatewayv2_authorizer.external.id
  #     throttling_rate_limit    = 80
  #     throttling_burst_limit   = 40
  #     detailed_metrics_enabled = true

  #     integration = {
  #       uri                    = module.lambda_function.lambda_function_arn
  #       payload_format_version = "2.0"
  #     }
  #   }

  #   "GET /some-route-with-authorizer" = {
  #     authorization_type = "JWT"
  #     authorizer_key     = "cognito"

  #     integration = {
  #       uri                    = module.lambda_function.lambda_function_arn
  #       payload_format_version = "2.0"
  #     }
  #   }

  #   "GET /some-route-with-authorizer-and-scope" = {
  #     authorization_type   = "JWT"
  #     authorizer_key       = "cognito"
  #     authorization_scopes = ["user.id", "user.email"]

  #     integration = {
  #       uri                    = module.lambda_function.lambda_function_arn
  #       payload_format_version = "2.0"
  #     }
  #   }

  #   "$default" = {
  #     integration = {
  #       uri = module.lambda_function.lambda_function_arn
  #       # tls_config = {
  #       #   server_name_to_verify = var.domain_name
  #       # }

  #       response_parameters = [
  #         {
  #           status_code = 500
  #           mappings = {
  #             "append:header.header1" = "$context.requestId"
  #             "overwrite:statuscode"  = "403"
  #           }
  #         },
  #         {
  #           status_code = 404
  #           mappings = {
  #             "append:header.error" = "$stageVariables.environmentId"
  #           }
  #         }
  #       ]
  #     }
  #   }
  # }

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

################################################################################
# Supporting Resources
################################################################################

# resource "aws_apigatewayv2_authorizer" "external" {
#   api_id           = module.api_gateway.api_id
#   authorizer_type  = "JWT"
#   identity_sources = ["$request.header.Authorization"]
#   name             = var.name

#   jwt_configuration {
#     audience = ["example"]
#     issuer   = "https://${aws_cognito_user_pool.this.endpoint}"
#   }
# }

# resource "aws_cognito_user_pool" "this" {
#   name = var.name
#   tags = local.tags
# }

module "lambda_function" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "hem-api-function"
  architectures  = ["arm64"]
  timeout        = 300
  create_package = false
  image_uri      = "317467111462.dkr.ecr.eu-west-2.amazonaws.com/hem-lambda-image-repository:hemlambdafunction-d309c0d00ba6-python3.9-hem"
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

################################################################################
# mTLS Supporting Resources
################################################################################

# module "s3_bucket" {
#   source  = "terraform-aws-modules/s3-bucket/aws"
#   version = "~> 3.0"

#   bucket_prefix = "${var.name}-"

#   # NOTE: This is enabled for example usage only, you should not enable this for production workloads
#   force_destroy = true

#   tags = local.tags
# }

# resource "aws_s3_object" "this" {
#   bucket                 = module.s3_bucket.s3_bucket_id
#   key                    = "truststore.pem"
#   server_side_encryption = "AES256"
#   content                = tls_self_signed_cert.this.cert_pem
# }

# resource "tls_private_key" "this" {
#   algorithm = "RSA"
# }

# resource "tls_self_signed_cert" "this" {
#   is_ca_certificate = true
#   private_key_pem   = tls_private_key.this.private_key_pem

#   subject {
#     common_name = "example.com"
#   }

#   validity_period_hours = 12

#   allowed_uses = [
#     "cert_signing",
#     "server_auth",
#   ]
# }

# resource "local_file" "key" {
#   content  = tls_private_key.this.private_key_pem
#   filename = "my-key.key"
# }

# resource "local_file" "pem" {
#   content  = tls_self_signed_cert.this.cert_pem
#   filename = "my-cert.pem"
# }
