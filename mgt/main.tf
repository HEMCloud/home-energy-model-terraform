terraform {
  cloud {

    organization = "hem-cloud"

    workspaces {
      name = "mgt"
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
  # MGT does not need to assume a role, as it's already running as admin
}

module "terraform_assume_dev_admin" {
  source                = "./modules/terraform_assume_member_account_admin"
  hcp_workspace         = "dev"
  member_account_id     = "${var.dev_account_id}"
  management_account_id = "${var.mgt_account_id}"
}
