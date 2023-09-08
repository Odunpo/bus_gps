# API
api_name        = "GpsRestApi_production"
api_stage_name  = "production"
api_role_name   = "gpsRestApiRole_production"
api_policy_name = "gpsRestApiRole_production"

# DYNAMODB
dynamodb_table_name     = "GpsCoordinatesTable_production"
dynamodb_read_capacity  = 10
dynamodb_write_capacity = 10

# KINESIS
kinesis_stream_name      = "GpsCoordinatesStream_production"
kinesis_shard_count      = 3
kinesis_retention_period = 24

# LAMBDA
lambda_consumer_function_name        = "GpsConsumerFunction_production"
lambda_consumer_role_name            = "lambdaGpsConsumerRole_production"
lambda_consumer_policy_name          = "lambda_GpsConsumerPolicy_production"
lambda_consumer_kinesis_batch_size   = 20
lambda_consumer_kinesis_retries      = 1
lambda_consumer_kinesis_window_secs  = 60
lambda_get_coordinates_function_name = "GetGpsFunction_production"
lambda_get_coordinates_role_name     = "lambdaGetGpsRole_production"
lambda_get_coordinates_policy_name   = "lambdaGetGpsPolicy_production"
s3_bucket_prefix                     = "gps-buses-kinesis-production"

# COGNITO
cognito_user_pool_name = "GpsCognitoUserPool_production"