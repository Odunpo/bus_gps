resource "aws_iam_role" "lambda_consumer_role" {
  name = var.lambda_consumer_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

data "aws_iam_policy_document" "lambda_consumer_policy_doc" {
  statement {
    actions = [
      "kinesis:DescribeStream",
      "kinesis:DescribeStreamSummary",
      "kinesis:GetRecords",
      "kinesis:GetShardIterator",
      "kinesis:ListShards",
      "kinesis:ListStreams",
      "kinesis:SubscribeToShard",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "dynamodb:PutItem",
      "dynamodb:BatchWriteItem"
    ]
    resources = [var.kinesis_arn, var.dynamodb_table_arn, "arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_consumer_policy" {
  name   = var.lambda_consumer_policy_name
  policy = data.aws_iam_policy_document.lambda_consumer_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_consumer_policy_attachment" {
  role       = aws_iam_role.lambda_consumer_role.name
  policy_arn = aws_iam_policy.lambda_consumer_policy.arn
}

resource "aws_iam_role" "lambda_get_coordinates_role" {
  name = var.lambda_get_coordinates_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

data "aws_iam_policy_document" "lambda_get_coordinates_policy_doc" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [var.dynamodb_table_arn, "arn:aws:logs:*:*:*"]
  }
}

resource "aws_iam_policy" "lambda_get_coordinates_policy" {
  name   = var.lambda_get_coordinates_policy_name
  policy = data.aws_iam_policy_document.lambda_get_coordinates_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "lambda_get_coordinates_policy_att" {
  role       = aws_iam_role.lambda_get_coordinates_role.name
  policy_arn = aws_iam_policy.lambda_get_coordinates_policy.arn
}