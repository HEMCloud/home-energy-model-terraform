module "hem_lambda_image_repository_commits" {
  source               = "../hem_modules/hem-ecr-repository"
  repository_name      = "hem-lambda-image-repository-commits"
  image_tag_mutability = "IMMUTABLE"
  account_ids          = local.all_account_ids
  region               = var.region
}
module "hem_lambda_image_repository_tags" {
  source               = "../hem_modules/hem-ecr-repository"
  repository_name      = "hem-lambda-image-repository-tags"
  image_tag_mutability = "IMMUTABLE"
  account_ids          = local.all_account_ids
  region               = var.region
}
module "api_lambda_image_repository_commits" {
  source               = "../hem_modules/hem-ecr-repository"
  repository_name      = "api-lambda-image-repository-commits"
  image_tag_mutability = "IMMUTABLE"
  account_ids          = local.all_account_ids
  region               = var.region
}
module "api_lambda_image_repository_tags" {
  source               = "../hem_modules/hem-ecr-repository"
  repository_name      = "api-lambda-image-repository-tags"
  image_tag_mutability = "IMMUTABLE"
  account_ids          = local.all_account_ids
  region               = var.region
}
