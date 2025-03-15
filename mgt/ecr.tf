resource "aws_ecr_repository" "hem_lambda_image_repository" {
  name                 = "hem-lambda-image-repository"
  image_tag_mutability = "IMMUTABLE"
}

resource "aws_ecr_repository_policy" "hem_lambda_image_repository_policy" {
  repository = aws_ecr_repository.hem_lambda_image_repository.name
  policy     = data.aws_iam_policy_document.hem_lambda_image_repository_policy.json
}

data "aws_iam_policy_document" "hem_lambda_image_repository_policy" {
  statement {
    sid     = "CrossAccountPermission"
    effect  = "Allow"
    actions = ["ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"]
    principals {
      type        = "AWS"
      identifiers = [for account_id in local.all_account_ids : "arn:aws:iam::${account_id}:root"]
    }
  }

  statement {
    sid     = "LambdaECRImageCrossAccountRetrievalPolicy"
    effect  = "Allow"
    actions = ["ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"]

    condition {
      test     = "StringLike"
      variable = "aws:sourceARN"
      values   = [for account_id in local.all_account_ids : "arn:aws:lambda:${var.region}:${account_id}:function:*"]
    }
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}