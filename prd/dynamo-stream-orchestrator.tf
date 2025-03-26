module "hem-model-run-stream-orchestrator" {
  source                             = "../hem_modules/hem-model-run-stream-orchestrator"
  build_artifacts_bucket_name        = var.build_artifacts_bucket_name
  dynamo_stream_lambda_s3_object_key = var.dynamo_stream_lambda_s3_object_key
  step_function_state_machine_arn    = module.hem-model-run-step-function.state_machine_arn
  dynamo_stream_arn                  = module.hem-model-run-dynamo.hem-model-run-dynamo-stream-arn
}
