module "github-oidc" {
  source  = "terraform-module/github-oidc-provider/aws"
  version = "2.2.1"

  create_oidc_provider = true
  create_oidc_role     = true

  repositories = ["HEMCloud/home-energy-model-api", "HEMCloud/home-energy-model-lambda"]
  oidc_role_attach_policies = [
    aws_iam_policy.github_action_permissions.arn,
  ]
}

data "aws_iam_policy_document" "github_action_permissions" {
  statement {
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart",
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
    ]
    resources = [aws_ecr_repository.hem_lambda_image_repository.arn]
  }
  statement {
    actions = [
      "sts:GetCallerIdentity",
      "ecr:GetAuthorizationToken" # * is required for GitHub Actions to authenticate to ECR
    ]
    resources = ["*"]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:ListBucket",
    ]
    resources = [
      aws_s3_bucket.hem_build_artifacts.arn,
      "${aws_s3_bucket.hem_build_artifacts.arn}/*",
    ]
  }
}

resource "aws_iam_policy" "github_action_permissions" {
  name        = "github-action-permissions"
  description = "GitHub Action permissions for HEM API and Lambda"
  policy      = data.aws_iam_policy_document.github_action_permissions.json
}


