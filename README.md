# Guide

This repo has been separted into one environment per directory. Each contains it's own HCP Terraform workspace, linked
to the cloud.

# Dev
I have set up dev to connect to the AWS Management Account in eu-west-2.

# Authentication
## HCP Terraform
Authentication with HCP Terraform has been configured using an API token, generated in their UI and saved in
`.terraformrc` in my home directory.

# AWS
I followed [this guide](https://aws.amazon.com/blogs/apn/simplify-and-secure-terraform-workflows-on-aws-with-dynamic-provider-credentials/)
to create a trusted OIDC connection between HCP Terraform and the AWS management account.

Terraform is currently configured with an admin role in the management account.



# TODO
Re setup dev to connect to a new account when the account quota limits have been increased (currently only one).

Consider creating a variable set in HCP Terraform that allows the OIDC connection to apply across all
workspaces/environments. This will need a new trust policy for the Terraform role that allows it to assume admin in the
sub-accounts (management is the parent) once created.