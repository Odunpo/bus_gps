resource "aws_dynamodb_table" "gps_table" {
  name           = var.dynamodb_table_name
  billing_mode   = "PROVISIONED"
  read_capacity  = var.dynamodb_read_capacity
  write_capacity = var.dynamodb_write_capacity
  hash_key       = var.dynamodb_hash_key

  attribute {
    name = var.dynamodb_hash_key
    type = "S"
  }

  ttl {
    enabled        = true
    attribute_name = var.dynamodb_ttl_field_name
  }
}