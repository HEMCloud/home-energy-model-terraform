locals {
  latest_hem_model_lambda_arn = "${module.hem-model-lambda.lambda_function_arn}:$LATEST"
  definition_template = templatefile(
    "${path.module}/step-function-definition.json",
    {
      latest_hem_model_lambda_arn = local.latest_hem_model_lambda_arn
  })
}

module "step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  name = "hem-model-runs-step-function"
  type = "STANDARD"

  definition = local.definition_template

  service_integrations = {
    dynamodb = {
      dynamodb = [module.hem-model-run-dynamo.hem-model-run-dynamo-table-arn]
    }

    lambda = {
      lambda = [
        module.hem-model-lambda.lambda_function_arn,
        local.latest_hem_model_lambda_arn
      ]
    }
  }

  attach_policies    = true
  number_of_policies = 1
  policies           = [aws_iam_policy.allow_step_function_s3_access.arn]
}

data "aws_iam_policy_document" "allow_step_function_s3_access" {
  statement {
    sid = "AllowStepFunctionS3Access"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      aws_s3_bucket.hem_model_runs.arn,
      "${aws_s3_bucket.hem_model_runs.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "allow_step_function_s3_access" {
  name        = "AllowStepFunctionS3Access"
  description = "Policy to allow the Step Function to access the S3 bucket"
  policy      = data.aws_iam_policy_document.allow_step_function_s3_access.json
}
