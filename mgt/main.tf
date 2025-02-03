terraform {
  cloud {

    organization = "hem-cloud"

    workspaces {
      name = "mgt"
    }
  }
}