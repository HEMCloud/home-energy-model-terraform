import {
    to = aws_iam_role.terraform_assume_dev_admin
    id = "TerraformAssumeDevAdmin"
}

resource "aws_iam_role" "terraform_assume_dev_admin" {
  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Condition = {
        StringEquals = {
          "app.terraform.io:aud" = "aws.workload.identity"
        }
        StringLike = {
          "app.terraform.io:sub" = "organization:*:project:*:workspace:*:run_phase:*"
        }
      }
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::317467111462:oidc-provider/app.terraform.io"
      }
    }]
    Version = "2012-10-17"
  })
  description          = "Role used by Terraform to assume OrganizationAccountAccessRole in the dev member account"
  max_session_duration = 3600
  name                 = "TerraformAssumeDevAdmin"
}