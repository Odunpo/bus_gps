# API
api_name        = "GpsRestApi_staging"
api_stage_name  = "staging"
api_role_name   = "gpsRestApiRole_staging"
api_policy_name = "gpsRestApiRole_staging"

# DYNAMODB
dynamodb_table_name     = "GpsCoordinatesTable_staging"
dynamodb_read_capacity  = 5
dynamodb_write_capacity = 5

# KINESIS
kinesis_stream_name      = "GpsCoordinatesStream_staging"
kinesis_shard_count      = 2
kinesis_retention_period = 24

# LAMBDA
lambda_consumer_function_name        = "GpsConsumerFunction_staging"
lambda_consumer_role_name            = "lambdaGpsConsumerRole_staging"
lambda_consumer_policy_name          = "lambda_GpsConsumerPolicy_staging"
lambda_consumer_kinesis_batch_size   = 10
lambda_consumer_kinesis_retries      = 1
lambda_consumer_kinesis_window_secs  = 60
lambda_get_coordinates_function_name = "GetGpsFunction_staging"
lambda_get_coordinates_role_name     = "lambdaGetGpsRole_staging"
lambda_get_coordinates_policy_name   = "lambdaGetGpsPolicy_staging"
s3_bucket_prefix                     = "gps-buses-kinesis-staging"

# COGNITO
cognito_user_pool_name = "GpsCognitoUserPool_staging"

# ROUTE 53
custom_domain_name = "your-staging-api.example.com"