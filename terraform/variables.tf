variable "aws_region" {
  type    = string
  default = "eu-north-1"
}


# API

variable "api_name" {
  type    = string
  default = "GpsRestApi"
}

variable "api_stage_name" {
  type    = string
  default = "default_stage"
}

variable "api_post_resource_path" {
  type    = string
  default = "post-gps"
}

variable "api_get_resource_path" {
  type    = string
  default = "get-gps"
}

variable "api_role_name" {
  type    = string
  default = "gpsRestApiRole"
}

variable "api_policy_name" {
  type    = string
  default = "gpsRestApiPolicy"
}

variable "api_authorizer_name" {
  type    = string
  default = "gpsCognitoAuthorizer"
}


# DYNAMODB

variable "dynamodb_table_name" {
  type    = string
  default = "GpsCoordinatesTable"
}

variable "dynamodb_read_capacity" {
  type    = number
  default = 1
}

variable "dynamodb_write_capacity" {
  type    = number
  default = 1
}

variable "dynamodb_hash_key" {
  type    = string
  default = "busId"
}

variable "dynamodb_ttl_seconds" {
  type    = string
  default = "3600"
}

variable "dynamodb_ttl_field_name" {
  type    = string
  default = "expirationTime"
}


# KINESIS

variable "kinesis_stream_name" {
  type    = string
  default = "GpsCoordinatesStream"
}

variable "kinesis_shard_count" {
  type    = number
  default = 1
}

variable "kinesis_retention_period" {
  type    = number
  default = 24
}


# LAMBDA

variable "lambda_consumer_role_name" {
  type    = string
  default = "lambdaGpsConsumerRole"
}

variable "lambda_consumer_policy_name" {
  type    = string
  default = "lambdaGpsConsumerPolicy"
}

variable "lambda_get_coordinates_role_name" {
  type    = string
  default = "lambdaGetGpsRole"
}

variable "lambda_get_coordinates_policy_name" {
  type    = string
  default = "lambdaGetGpsPolicy"
}

variable "lambda_consumer_function_name" {
  type    = string
  default = "GpsConsumerFunction"
}

variable "lambda_consumer_kinesis_batch_size" {
  type    = number
  default = 2
}

variable "lambda_consumer_kinesis_retries" {
  type    = number
  default = 1
}

variable "lambda_consumer_kinesis_window_secs" {
  type    = number
  default = 60
}

variable "lambda_get_coordinates_function_name" {
  type    = string
  default = "GetGpsFunction"
}

variable "s3_bucket_prefix" {
  type    = string
  default = "gps-buses-kinesis"
}

variable "s3_lambda_consumer_key" {
  type    = string
  default = "lambda_consumer.zip"
}

variable "s3_lambda_get_coordinates_key" {
  type    = string
  default = "lambda_get_coordinates.zip"
}


# COGNITO

variable "cognito_user_pool_name" {
  type    = string
  default = "GpsCognitoUserPool"
}

variable "cognito_user_pool_client_name" {
  type    = string
  default = "GpsCognitoUserPoolClient"
}


# ROUTE 53

variable "custom_domain_name" {
  type    = string
  default = "your-api.example.com"
}

variable "route53_public_zone_name" {
  type    = string
  default = "example.com"
}