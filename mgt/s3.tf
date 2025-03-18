resource "aws_s3_bucket" "hem_build_artifacts" {
  bucket = "hem-build-artifacts"
}

resource "aws_s3_bucket_policy" "hem_build_artifacts_policy" {
  bucket = aws_s3_bucket.hem_build_artifacts.id
  policy = data.aws_iam_policy_document.hem_build_artifacts_policy.json
}

data "aws_iam_policy_document" "hem_build_artifacts_policy" {
  statement {
    sid       = "AllowCrossAccountGetObject"
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:GetObjectTagging"]
    resources = ["${aws_s3_bucket.hem_build_artifacts.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = [for account_id in local.all_account_ids : "arn:aws:iam::${account_id}:root"]
    }
  }
}
