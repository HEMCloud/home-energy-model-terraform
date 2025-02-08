resource "aws_iam_role" "terraform_assume_member_admin" {
  assume_role_policy   = data.aws_iam_policy_document.trust_terraform_to_assume_role.json
  description          = "Role used by Terraform to assume OrganizationAccountAccessRole in the ${var.hcp_workspace} member account"
  max_session_duration = 3600
  name                 = "TerraformAssume${var.hcp_workspace}Admin"
}

resource "aws_iam_role_policy_attachment" "allow_assume_member_admin" {
  policy_arn = aws_iam_policy.allow_assume_member_admin.arn
  role       = aws_iam_role.terraform_assume_member_admin.name
}

data "aws_iam_policy_document" "trust_terraform_to_assume_role" {
  statement {
    sid     = "Allow${local.capitalised_hcp_workspace}TerraformWorkspaceToAssumeRole"
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
      identifiers = ["arn:aws:iam::${var.management_account_id}:oidc-provider/app.terraform.io"]
    }
  }
}

resource "aws_iam_policy" "allow_assume_member_admin" {
  description = "Permission to assume the OrganizationAccountAccessRole in the ${var.hcp_workspace} member account."
  name        = "AllowTerraformToAssume${local.capitalised_hcp_workspace}AccountAdmin"
  policy      = data.aws_iam_policy_document.allow_assume_member_admin.json
}

data "aws_iam_policy_document" "allow_assume_member_admin" {
  statement {
    sid       = "AllowTerraformToAssume${local.capitalised_hcp_workspace}AccountAdmin"
    effect    = "Allow"
    resources = ["arn:aws:iam::${var.member_account_id}:role/OrganizationAccountAccessRole"]
    actions   = ["sts:AssumeRole"]
  }
}
