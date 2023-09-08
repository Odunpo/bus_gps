module "dynamodb" {
  source                  = "./dynamodb"
  dynamodb_table_name     = var.dynamodb_table_name
  dynamodb_read_capacity  = var.dynamodb_read_capacity
  dynamodb_write_capacity = var.dynamodb_write_capacity
  dynamodb_hash_key       = var.dynamodb_hash_key
  dynamodb_ttl_field_name = var.dynamodb_ttl_field_name
}

module "kinesis" {
  source                   = "./kinesis"
  kinesis_stream_name      = var.kinesis_stream_name
  kinesis_shard_count      = var.kinesis_shard_count
  kinesis_retention_period = var.kinesis_retention_period
}

module "lambda" {
  source                               = "./lambda"
  lambda_consumer_function_name        = var.lambda_consumer_function_name
  lambda_consumer_kinesis_batch_size   = var.lambda_consumer_kinesis_batch_size
  lambda_consumer_kinesis_retries      = var.lambda_consumer_kinesis_retries
  lambda_consumer_kinesis_window_secs  = var.lambda_consumer_kinesis_window_secs
  lambda_consumer_role_name            = var.lambda_consumer_role_name
  lambda_consumer_policy_name          = var.lambda_consumer_policy_name
  lambda_get_coordinates_function_name = var.lambda_get_coordinates_function_name
  lambda_get_coordinates_role_name     = var.lambda_get_coordinates_role_name
  lambda_get_coordinates_policy_name   = var.lambda_get_coordinates_policy_name
  s3_bucket_prefix                     = var.s3_bucket_prefix
  s3_lambda_consumer_key               = var.s3_lambda_consumer_key
  s3_lambda_get_coordinates_key        = var.s3_lambda_get_coordinates_key
  dynamodb_table_name                  = var.dynamodb_table_name
  dynamodb_ttl_seconds                 = var.dynamodb_ttl_seconds
  dynamodb_ttl_field_name              = var.dynamodb_ttl_field_name
  kinesis_arn                          = module.kinesis.kinesis_arn
  dynamodb_table_arn                   = module.dynamodb.dynamodb_table_arn
  lambda_consumer_source_dir           = "${path.module}/../src/lambda_kinesis_consumer"
  lambda_consumer_output_path          = "${path.module}/../lambda_kinesis_consumer.zip"
  lambda_get_coordinates_source_dir    = "${path.module}/../src/get_coordinates_function"
  lambda_get_coordinates_output_path   = "${path.module}/../lambda_get_coordinates.zip"
}

module "api" {
  source                               = "./api"
  aws_region                           = var.aws_region
  api_name                             = var.api_name
  api_stage_name                       = var.api_stage_name
  api_post_gps_resource_path           = var.api_post_resource_path
  api_get_gps_resource_path            = var.api_get_resource_path
  api_role_name                        = var.api_role_name
  api_policy_name                      = var.api_policy_name
  api_authorizer_name                  = var.api_authorizer_name
  api_cognito_user_pool_arn            = module.cognito.cognito_user_pool_arn
  kinesis_arn                          = module.kinesis.kinesis_arn
  lambda_kinesis_function_name         = module.lambda.lambda_consumer_function_name
  lambda_kinesis_invoke_arn            = module.lambda.lambda_consumer_invoke_arn
  lambda_get_coordinates_function_name = module.lambda.lambda_get_coordinates_function_name
  lambda_get_coordinates_invoke_arn    = module.lambda.lambda_get_coordinates_invoke_arn
}

module "cognito" {
  source                        = "./cognito"
  cognito_user_pool_name        = var.cognito_user_pool_name
  cognito_user_pool_client_name = var.cognito_user_pool_client_name
}

module "route53" {
  source                     = "./route53"
  custom_domain_name         = var.custom_domain_name
  route53_public_zone_name   = var.route53_public_zone_name
  post_coordinates_api_id    = module.api.api_id
  post_coordinates_api_stage = module.api.api_stage
}