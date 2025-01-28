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
    role_arn = "arn:aws:iam::864981718509:role/OrganizationAccountAccessRole"
  }
}