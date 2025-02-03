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

resource "aws_iam_policy" "allow_terraform_to_assume_dev_admin" {
  description = "Used to allow Terraform to assume the OrganizationAccountAccessRole in the dev member account."
  name        = "AllowTerraformToAssumeDevAccountAdmin"
  policy = jsonencode({
    Statement = [{
      Action   = "sts:AssumeRole"
      Effect   = "Allow"
      Resource = "arn:aws:iam::864981718509:role/OrganizationAccountAccessRole"
      Sid      = "VisualEditor0"
    }]
    Version = "2012-10-17"
  })
}
