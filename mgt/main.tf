terraform {
  cloud {

    organization = "hem-cloud"

    workspaces {
      name = "mgt"
    }
  }
}

provider "aws" {
  region = "eu-west-2"

  assume_role {
    # Mgt/root account
    role_arn = "arn:aws:iam::317467111462:role/TerraformAdmin"
  }
}