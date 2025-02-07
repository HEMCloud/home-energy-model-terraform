resource "aws_iam_role" "terraform_assume_dev_admin" {
  assume_role_policy   = data.aws_iam_policy_document.assume_member_admin_trust_policy.json
  description          = "Role used by Terraform to assume OrganizationAccountAccessRole in the dev member account"
  max_session_duration = 3600
  name                 = "TerraformAssumeDevAdmin"
}

data "aws_iam_policy_document" "assume_member_admin_trust_policy" {
  statement {
    sid     = "AllowTerraformToAssumeMemberAccountAdmin"
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    condition {
      test     = "StringEquals"
      variable = "app.terraform.io:aud"
      values   = ["aws.workload.identity"]
    }

    condition {
      test     = "StringLike"
      variable = "app.terraform.io:sub"
      values   = ["organization:${var.hcp_organization}:project:${var.hcp_project}:workspace:${var.hcp_workspace}:run_phase:*"]
    }
    principals {
      type        = "Federated"
      identifiers = ["arn:aws:iam::317467111462:oidc-provider/app.terraform.io"]
    }
  }
}

resource "aws_iam_policy" "allow_terraform_to_assume_dev_admin" {
  description = "Permission to assume the OrganizationAccountAccessRole in the dev member account."
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

resource "aws_iam_role_policy_attachment" "allow_terraform_to_assume_dev_admin" {
  policy_arn = aws_iam_policy.allow_terraform_to_assume_dev_admin.arn
  role       = aws_iam_role.terraform_assume_dev_admin.name
}
