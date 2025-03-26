data "aws_iam_policy_document" "allow_dynamo_stream_access" {
  statement {
    sid    = "AllowDynamoStreamAccess"
    effect = "Allow"
    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams",
    ]
    resources = [
      var.dynamo_stream_arn,
    ]
  }
}

resource "aws_iam_policy" "allow_dynamo_stream_access" {
  name        = "AllowDynamoStreamAccess"
  description = "Policy to allow access to DynamoDB streams for hem-model-runs"
  policy      = data.aws_iam_policy_document.allow_dynamo_stream_access.json
}

resource "aws_iam_role_policy_attachment" "attach_dynamo_stream_policy" {
  role       = module.dynamo-lambda.lambda_role_name
  policy_arn = aws_iam_policy.allow_dynamo_stream_access.arn
}

data "aws_iam_policy_document" "allow_step_function_start_execution" {
  statement {
    sid    = "AllowStepFunctionStartExecution"
    effect = "Allow"
    actions = [
      "states:StartExecution",
    ]
    resources = [
      var.step_function_state_machine_arn,
    ]
  }
}

resource "aws_iam_policy" "allow_step_function_start_execution" {
  name        = "AllowStepFunctionStartExecution"
  description = "Policy to allow the Lambda to start the Step Function"
  policy      = data.aws_iam_policy_document.allow_step_function_start_execution.json
}

resource "aws_iam_role_policy_attachment" "attach_step_function_start_execution_policy" {
  role       = module.dynamo-lambda.lambda_role_name
  policy_arn = aws_iam_policy.allow_step_function_start_execution.arn
}
