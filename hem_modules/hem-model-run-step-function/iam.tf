data "aws_iam_policy_document" "allow_step_function_s3_access" {
  statement {
    sid = "AllowStepFunctionS3Access"

    actions = [
      "s3:GetObject",
      "s3:ListBucket",
      "s3:PutObject",
    ]

    resources = [
      var.hem_model_run_s3_bucket_arn,
      "${var.hem_model_run_s3_bucket_arn}/*",
    ]
  }
}

resource "aws_iam_policy" "allow_step_function_s3_access" {
  name        = "AllowStepFunctionS3Access"
  description = "Policy to allow the Step Function to access the S3 bucket"
  policy      = data.aws_iam_policy_document.allow_step_function_s3_access.json
}
