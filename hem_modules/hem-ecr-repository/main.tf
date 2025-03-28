resource "aws_ecr_repository" "repository" {
  name                 = var.repository_name
  image_tag_mutability = var.image_tag_mutability
}

resource "aws_ecr_repository_policy" "repository_policy" {
  repository = aws_ecr_repository.repository.name
  policy     = data.aws_iam_policy_document.repository_policy.json
}

data "aws_iam_policy_document" "repository_policy" {
  statement {
    sid     = "CrossAccountPermission"
    effect  = "Allow"
    actions = ["ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"]
    principals {
      type        = "AWS"
      identifiers = [for account_id in var.account_ids : "arn:aws:iam::${account_id}:root"]
    }
  }

  statement {
    sid     = "LambdaECRImageCrossAccountRetrievalPolicy"
    effect  = "Allow"
    actions = ["ecr:BatchGetImage", "ecr:GetDownloadUrlForLayer"]

    condition {
      test     = "StringLike"
      variable = "aws:sourceARN"
      values   = [for account_id in var.account_ids : "arn:aws:lambda:${var.region}:${account_id}:function:*"]
    }
    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}
