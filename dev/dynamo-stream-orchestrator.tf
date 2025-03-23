module "dynamo-lambda" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "dynamo-stream-orchestrator"
  runtime        = "python3.13"
  handler        = "function.lambda_handler"
  create_package = false
  s3_existing_package = {
    bucket = var.build_artifacts_bucket_name
    key    = "dynamo-stream-orchestrator-lambda-zips/dea0301a5eb3ba0f4ab77a6a4723b75a"
  }
}

resource "aws_lambda_event_source_mapping" "dynamo-stream-orchestrator" {
  event_source_arn  = module.dynamodb_table.dynamodb_table_stream_arn
  function_name     = module.dynamo-lambda.lambda_function_name
  starting_position = "LATEST"
  filter_criteria {
    filter {
      pattern = jsonencode({ "eventName" : ["INSERT"] })
    }
  }
  depends_on = [aws_iam_role_policy_attachment.attach_dynamo_stream_policy]
}

data "aws_iam_policy_document" "allow_dynamo_stream_access" {
  statement {
    sid = "AllowDynamoStreamAccess"

    effect = "Allow"

    actions = [
      "dynamodb:DescribeStream",
      "dynamodb:GetRecords",
      "dynamodb:GetShardIterator",
      "dynamodb:ListStreams",
    ]

    resources = [
      module.dynamodb_table.dynamodb_table_stream_arn,
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
