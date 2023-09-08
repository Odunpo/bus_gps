resource "aws_iam_role" "gps_api_role" {
  name = var.api_role_name
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "apigateway.amazonaws.com"
      }
    }]
  })
}

data "aws_iam_policy_document" "gps_api_policy_doc" {
  statement {
    sid = ""
    actions = [
      "kinesis:PutRecord",
      "kinesis:PutRecords"
    ]
    resources = [var.kinesis_arn]
  }
}

resource "aws_iam_policy" "gps_api_policy" {
  name   = var.api_policy_name
  policy = data.aws_iam_policy_document.gps_api_policy_doc.json
}

resource "aws_iam_role_policy_attachment" "gps_api_role_policy_attachment" {
  role       = aws_iam_role.gps_api_role.name
  policy_arn = aws_iam_policy.gps_api_policy.arn
}