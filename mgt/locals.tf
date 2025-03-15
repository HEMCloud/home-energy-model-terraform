locals {
  all_account_ids = [
    var.dev_account_id,
    var.prd_account_id,
    var.mgt_account_id
  ]
}
