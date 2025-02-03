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
