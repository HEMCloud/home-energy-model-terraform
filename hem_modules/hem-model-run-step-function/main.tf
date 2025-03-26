locals {
  latest_hem_model_lambda_arn = "${var.hem_model_lambda_arn}:$LATEST"
  definition_template = templatefile(
    "${path.module}/step-function-definition.asl.json",
    {
      latest_hem_model_lambda_arn     = local.latest_hem_model_lambda_arn
      hem-model-run-dynamo-table-name = var.hem_model_run_dynamo_table_name
      hem-model-run-bucket-name       = var.hem_model_run_s3_bucket_name
  })
}

module "hem_model_run_step_function" {
  source = "terraform-aws-modules/step-functions/aws"

  name = "hem-model-runs-step-function"
  type = "STANDARD"

  definition = local.definition_template

  service_integrations = {
    dynamodb = {
      dynamodb = [var.hem_model_run_dynamo_table_arn]
    }

    lambda = {
      lambda = [
        var.hem_model_lambda_arn,
        local.latest_hem_model_lambda_arn
      ]
    }
  }

  attach_policies    = true
  number_of_policies = 1
  policies           = [aws_iam_policy.allow_step_function_s3_access.arn]
}
