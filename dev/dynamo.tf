module "dynamodb_table" {
  source = "terraform-aws-modules/dynamodb-table/aws"

  name     = "hem-model-runs"
  hash_key = "uuid"

  attributes = [
    {
      name = "uuid"
      type = "S"
    }
  ]

  tags = {
    Terraform = "true"
  }

  stream_enabled   = true
  stream_view_type = "NEW_AND_OLD_IMAGES"
}
