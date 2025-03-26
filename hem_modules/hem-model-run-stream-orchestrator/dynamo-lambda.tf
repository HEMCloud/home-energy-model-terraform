module "dynamo-lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "dynamo-stream-orchestrator"
  runtime        = "python3.13"
  handler        = "function.lambda_handler"
  create_package = false
  s3_existing_package = {
    bucket = var.build_artifacts_bucket_name
    key    = var.dynamo_stream_lambda_s3_object_key
  }
  environment_variables = {
    "STATE_MACHINE_ARN" = var.step_function_state_machine_arn
  }
}

resource "aws_lambda_event_source_mapping" "dynamo-stream-orchestrator" {
  event_source_arn  = var.dynamo_stream_arn
  function_name     = module.dynamo-lambda.lambda_function_name
  starting_position = "LATEST"
  filter_criteria {
    filter {
      pattern = jsonencode({ "eventName" : ["INSERT"] })
    }
  }
  depends_on = [aws_iam_role_policy_attachment.attach_dynamo_stream_policy]
}
