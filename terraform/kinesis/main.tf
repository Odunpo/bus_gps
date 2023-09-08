resource "aws_kinesis_stream" "kinesis_stream" {
  name             = var.kinesis_stream_name
  shard_count      = var.kinesis_shard_count
  retention_period = var.kinesis_retention_period

  stream_mode_details {
    stream_mode = "PROVISIONED"
  }
}