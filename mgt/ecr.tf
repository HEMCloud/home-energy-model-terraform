resource "aws_ecr_repository" "hem_lambda_image_repository" {
  name                 = "hem-lambda-image-repository"
  image_tag_mutability = "IMMUTABLE"
}