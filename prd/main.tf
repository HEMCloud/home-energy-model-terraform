terraform {
  cloud {

    organization = "hem-cloud"

    workspaces {
      name = "prd"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  assume_role {
    role_arn = "arn:aws:iam::${var.prd_account_id}:role/OrganizationAccountAccessRole"
  }
}