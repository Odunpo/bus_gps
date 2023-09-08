resource "random_pet" "lambda_bucket_name" {
  prefix = var.s3_bucket_prefix
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id
}

data "archive_file" "lambda_consumer" {
  type        = "zip"
  source_dir  = var.lambda_consumer_source_dir
  output_path = var.lambda_consumer_output_path
}

resource "aws_s3_object" "lambda_consumer" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = var.s3_lambda_consumer_key
  source = data.archive_file.lambda_consumer.output_path
  etag   = filemd5(data.archive_file.lambda_consumer.output_path)
}

data "archive_file" "lambda_get_coordinates" {
  type        = "zip"
  source_dir  = var.lambda_get_coordinates_source_dir
  output_path = var.lambda_get_coordinates_output_path
}

resource "aws_s3_object" "lambda_get_coordinates" {
  bucket = aws_s3_bucket.lambda_bucket.id
  key    = var.s3_lambda_get_coordinates_key
  source = data.archive_file.lambda_get_coordinates.output_path
  etag   = filemd5(data.archive_file.lambda_get_coordinates.output_path)
}