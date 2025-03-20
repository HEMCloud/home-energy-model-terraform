module "lambda_function_container_image" {
  source         = "terraform-aws-modules/lambda/aws"
  function_name  = "hem-lambda-function"
  architectures  = ["arm64"]
  timeout        = 300
  create_package = false
  image_uri      = "317467111462.dkr.ecr.eu-west-2.amazonaws.com/hem-lambda-image-repository:hemlambdafunction-d309c0d00ba6-python3.9-hem"
  package_type   = "Image"
}

data "aws_iam_policy_document" "allow_invoke_hem_lambda" {
  statement {
    sid = "AllowLambdaInvoke"

    actions = [
      "lambda:InvokeFunction",
    ]

    resources = [
      module.lambda_function_container_image.lambda_function_arn,
    ]
  }
}

resource "aws_iam_policy" "allow_invoke_lambda" {
  name        = "AllowInvokeLambda"
  description = "Policy to allow invoking the HEM Lambda function"
  policy      = data.aws_iam_policy_document.allow_invoke_hem_lambda.json
}

resource "aws_iam_role_policy_attachment" "attach_invoke_lambda_policy" {
  role       = module.complete-api-gateway.lambda_role_name
  policy_arn = aws_iam_policy.allow_invoke_lambda.arn
}

