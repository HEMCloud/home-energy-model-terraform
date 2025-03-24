# IAM policy document for HEM model runs
data "aws_iam_policy_document" "hem_model_runs_policy" {
  statement {
    actions = [
      "s3:PutObject",
      "s3:PutObjectAcl"
    ]
    resources = [
      "${var.hem_model_runs_bucket_arn}/*"
    ]
  }

  statement {
    actions = [
      "dynamodb:PutItem"
    ]
    resources = [
      var.hem_model_runs_dynamo_table_arn
    ]
  }
}

# Create the IAM policy
resource "aws_iam_policy" "hem_model_runs_policy" {
  name        = "hem-model-runs-policy"
  description = "Policy allowing Lambda to PUT objects in the HEM model runs S3 bucket and DynamoDB table"
  policy      = data.aws_iam_policy_document.hem_model_runs_policy.json
}

# Attach the policy to the Lambda function's IAM role
resource "aws_iam_role_policy_attachment" "lambda_hem_model_runs_policy_attachment" {
  role       = module.lambda_function.lambda_role_name
  policy_arn = aws_iam_policy.hem_model_runs_policy.arn
}
