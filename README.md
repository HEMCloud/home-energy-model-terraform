# Guide

This repo has been separted into one environment per directory. Each contains it's own HCP Terraform workspace, linked
to the cloud.

# Mgt
There is a central management account in AWS, used to control other accounts. The MGT account is in eu-west-2.

# Dev
I have set up a member account in the management account's organisation. 
By default an admin role is created 'OrganizationAccountAccessRole`. This allows any principal in the management account
to assume Admin privileges.

# Authentication
## HCP Terraform
Authentication with HCP Terraform has been configured using an API token, generated in their UI and saved in
`.terraformrc` in my home directory.

# AWS
I followed [this guide](https://aws.amazon.com/blogs/apn/simplify-and-secure-terraform-workflows-on-aws-with-dynamic-provider-credentials/)
to create a trusted OIDC connection between HCP Terraform and the AWS management account. Terraform is currently configured with an admin role in the management account.

I further created a policy and role that allowed Terraform to assume the 'OrganizationAccountAccessRole` in the dev
member account. I used [this guide](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access-cross-account-role.html)
but instead used the `AssumeRoleWithWebIdentity` action in the policy. I then used the above guide to create a trust policy for
the Terraform identity provider.



# TODO
Re setup dev to connect to a new account when the account quota limits have been increased (currently only one).

Consider creating a variable set in HCP Terraform that allows the OIDC connection to apply across all
workspaces/environments. This will need a new trust policy for the Terraform role that allows it to assume admin in the
sub-accounts (management is the parent) once created.