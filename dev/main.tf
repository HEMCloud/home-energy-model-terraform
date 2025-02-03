terraform {
  cloud {

    organization = "hem-cloud"

    workspaces {
      name = "dev"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">=5.84.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  assume_role {
    # Dev account
    role_arn = "arn:aws:iam::${var.dev_account_id}:role/OrganizationAccountAccessRole"
  }
}
