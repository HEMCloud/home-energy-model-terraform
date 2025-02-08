resource "aws_iam_role" "terraform_assume_member_admin" {
  assume_role_policy   = data.aws_iam_policy_document.trust_terraform_to_assume_role.json
  description          = "Role used by Terraform to assume OrganizationAccountAccessRole in the dev member account"
  max_session_duration = 3600
  name                 = "TerraformAssumeDevAdmin"
}

data "aws_iam_policy_document" "trust_terraform_to_assume_role" {
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

resource "aws_iam_policy" "allow_assume_member_admin" {
  description = "Permission to assume the OrganizationAccountAccessRole in the dev member account."
  name        = "AllowTerraformToAssumeDevAccountAdmin"
  policy = data.aws_iam_policy_document.allow_assume_member_admin.json
}

data "aws_iam_policy_document" "allow_assume_member_admin" {
  statement {
    sid = "AllowTerraformToAssumeAccountAdmin"
    effect = "Allow"
    resources = ["arn:aws:iam::864981718509:role/OrganizationAccountAccessRole"]
    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role_policy_attachment" "allow_assume_member_admin" {
  policy_arn = aws_iam_policy.allow_assume_member_admin.arn
  role       = aws_iam_role.terraform_assume_member_admin.name
}
