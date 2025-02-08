# Guide

This repo has been separted into one environment per directory. Each contains it's own HCP Terraform workspace, linked
to the cloud.

# Root AWS Account

## Management (MGT)
There is a central management account in AWS, used to control other accounts. The MGT account is in eu-west-2. It's
controlled by the root user login. It uses my default email address.

# Member AWS Accounts
I have set up multiple member accounts in the management account's organisation. By default an admin role is created
called 'OrganizationAccountAccessRole`. This has a default trust policy that allows any principal in the
management account to assume the role.

## Development (DEV)
Dev is used for testing new changes. It's registered with my default email address and 'plus address' suffix of
'+hem_aws_dev'.

# Initial Terraform Setup guide
There are a series of manual and Terraform controlled changes to setup the AWS accounts.

## AWS Management Process
1. Create a new identity provider in IAM for the HCP Terraform application, with a Provider URL of
   `https://app.terraform.io` and an Audience of `aws.workload.identity`.
2. Add a new role for the MGT Terraform workspace to assume in IAM. Note the ARN, as it's needed for the HCP Terraform steps below. It should have an `AdministratorAccess` policy and the following trust policy:
   ```
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::<ACCOUNT_ID_HERE>:oidc-provider/app.terraform.io"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "app.terraform.io:aud": "aws.workload.identity"
                },
                "StringLike": {
                    "app.terraform.io:sub": "organization:<HCP_ORG_NAME_HERE>:project:<HCP_PROJECT_NAME_HERE>:workspace:<MANAGEMENT_WORKSPACE_NAME_HERE>:run_phase:*"
                }
            }
        }
    ]
    }
    ```   

## AWS Organizations
1. In the Management account, navigate to AWS Organizations.
2. Under the 'Root' Organization Unit, add a new account.
3. Fill in the form, using a 'plus address' suffix to your normal email address for the owner.

## Hashicorp Terraform
For each AWS Account including 'MGT':
1. In the HCP Terraform UI, create a new Workspace.
2. If not a development workspace (e.g prod), setup a VCS connection and target a subdirectory of this repo.
3. If a development workspace, leave it to be CLI controlled only. 
4. In the Workspace to be controlled add two new variables:
   1. `TFC_AWS_PROVIDER_AUTH` = `true`, category env.
   2. `TFC_AWS_RUN_ROLE_ARN` = `<ROLE_ARN>`, category env.
      - If 'MGT', use the role created manually above in the MGT account.
      - If not, use the `TerraformAssume<ENV>Admin` created by the Terraform module in this repo. This is the role used to
        get an auth token from, while the `OrganizationAccountAccessRole` role configured in each environment's
        `main.tf` provider block is the role used to make configuration changes in that account.

## Terraform CLI access
Authentication with HCP Terraform (Cloud) from the CLI has been configured using an API token, generated in their UI and saved in
`.terraformrc` in my home directory. This allows plan and apply runs to be triggered from the terminal.

## Run Terraform from this repo
1. Add a new Terraform IAM AssumeEnvAdmin role module instantiation, passing the variables needed.
2. Terraform apply the 'MGT' workspace to apply the new IAM role and policy created.
3. Add a new subdirectory to this repo.
4. Add a `main.tf` with a `cloud` block targeting the workspace name created above.
5. Add a `provider "aws"` block with an `assume_role` attribute. This should be the ARN of the default
   OrganizationAccountAccessRole created when the member account was added. Note, the `TFC_AWS_RUN_ROLE_ARN` is the
   `TerraformAssume<ENV>Admin` role used to authenticate in MGT, while this `assume_role` is the
   `OrganizationAccountAccessRole` role in the member account used to make infrastructure changes.
6. Run `terraform init`.

## References
[AWS Cross organisation account auth](https://docs.aws.amazon.com/organizations/latest/userguide/orgs_manage_accounts_access-cross-account-role.html)

[HCP Terraform OIDC connection with AWS](https://aws.amazon.com/blogs/apn/simplify-and-secure-terraform-workflows-on-aws-with-dynamic-provider-credentials/)