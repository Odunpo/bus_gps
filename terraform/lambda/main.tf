resource "aws_lambda_function" "lambda_consumer" {
  function_name = var.lambda_consumer_function_name

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_consumer.key

  runtime = "python3.9"
  handler = "index.lambda_handler"

  source_code_hash = data.archive_file.lambda_consumer.output_base64sha256

  role = aws_iam_role.lambda_consumer_role.arn

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
      TTL_SECONDS         = var.dynamodb_ttl_seconds
      TTL_FIELD_NAME      = var.dynamodb_ttl_field_name
    }
  }
}

resource "aws_lambda_event_source_mapping" "lambda_consumer_source_mapping" {
  function_name                      = aws_lambda_function.lambda_consumer.arn
  event_source_arn                   = var.kinesis_arn
  starting_position                  = "TRIM_HORIZON"
  batch_size                         = var.lambda_consumer_kinesis_batch_size
  maximum_retry_attempts             = var.lambda_consumer_kinesis_retries
  maximum_batching_window_in_seconds = var.lambda_consumer_kinesis_window_secs

  depends_on = [aws_iam_role_policy_attachment.lambda_consumer_policy_attachment]
}

resource "aws_lambda_function" "lambda_get_coordinates" {
  function_name = var.lambda_get_coordinates_function_name

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_object.lambda_get_coordinates.key

  runtime = "python3.9"
  handler = "index.lambda_handler"

  source_code_hash = data.archive_file.lambda_get_coordinates.output_base64sha256

  role = aws_iam_role.lambda_get_coordinates_role.arn

  environment {
    variables = {
      DYNAMODB_TABLE_NAME = var.dynamodb_table_name
    }
  }
}