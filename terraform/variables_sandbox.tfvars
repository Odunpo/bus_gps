# API
api_name        = "GpsRestApi_sandbox"
api_stage_name  = "sandbox"
api_role_name   = "gpsRestApiRole_sandbox"
api_policy_name = "gpsRestApiRole_sandbox"

# DYNAMODB
dynamodb_table_name     = "GpsCoordinatesTable_sandbox"
dynamodb_read_capacity  = 1
dynamodb_write_capacity = 1

# KINESIS
kinesis_stream_name      = "GpsCoordinatesStream_sandbox"
kinesis_shard_count      = 1
kinesis_retention_period = 24

# LAMBDA
lambda_consumer_function_name        = "GpsConsumerFunction_sandbox"
lambda_consumer_role_name            = "lambdaGpsConsumerRole_sandbox"
lambda_consumer_policy_name          = "lambda_GpsConsumerPolicy_sandbox"
lambda_consumer_kinesis_batch_size   = 1
lambda_consumer_kinesis_retries      = 1
lambda_consumer_kinesis_window_secs  = 60
lambda_get_coordinates_function_name = "GetGpsFunction_sandbox"
lambda_get_coordinates_role_name     = "lambdaGetGpsRole_sandbox"
lambda_get_coordinates_policy_name   = "lambdaGetGpsPolicy_sandbox"
s3_bucket_prefix                     = "gps-buses-kinesis-sandbox"

# COGNITO
cognito_user_pool_name = "GpsCognitoUserPool_sandbox"

# ROUTE 53
custom_domain_name = "your-sandbox-api.example.com"