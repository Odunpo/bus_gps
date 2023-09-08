resource "aws_api_gateway_rest_api" "gps_api" {
  name = var.api_name

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_authorizer" "cognito_authorizer" {
  name          = var.api_authorizer_name
  rest_api_id   = aws_api_gateway_rest_api.gps_api.id
  type          = "COGNITO_USER_POOLS"
  provider_arns = [var.api_cognito_user_pool_arn]
}

resource "aws_api_gateway_resource" "post_gps_resource" {
  rest_api_id = aws_api_gateway_rest_api.gps_api.id
  parent_id   = aws_api_gateway_rest_api.gps_api.root_resource_id
  path_part   = var.api_post_gps_resource_path
}

resource "aws_api_gateway_resource" "get_gps_resource" {
  rest_api_id = aws_api_gateway_rest_api.gps_api.id
  parent_id   = aws_api_gateway_rest_api.gps_api.root_resource_id
  path_part   = var.api_get_gps_resource_path
}

resource "aws_api_gateway_method" "post_gps_method" {
  http_method   = "POST"
  rest_api_id   = aws_api_gateway_rest_api.gps_api.id
  resource_id   = aws_api_gateway_resource.post_gps_resource.id
  authorization = "COGNITO_USER_POOLS"
  authorizer_id = aws_api_gateway_authorizer.cognito_authorizer.id
}

resource "aws_api_gateway_method" "get_gps_method" {
  http_method   = "GET"
  rest_api_id   = aws_api_gateway_rest_api.gps_api.id
  resource_id   = aws_api_gateway_resource.get_gps_resource.id
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "post_gps_kinesis_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gps_api.id
  resource_id             = aws_api_gateway_resource.post_gps_resource.id
  http_method             = aws_api_gateway_method.post_gps_method.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = "arn:aws:apigateway:${var.aws_region}:kinesis:action/PutRecord"
  credentials             = aws_iam_role.gps_api_role.arn
}

resource "aws_api_gateway_integration" "get_gps_lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.gps_api.id
  resource_id             = aws_api_gateway_resource.get_gps_resource.id
  http_method             = aws_api_gateway_method.get_gps_method.http_method
  type                    = "AWS"
  integration_http_method = "POST"
  uri                     = var.lambda_get_coordinates_invoke_arn

  request_templates = {
    "application/json" = jsonencode({
      "busId" = "$input.params('busId')"
    })
  }
}

resource "aws_lambda_permission" "api_gw_get" {
  action        = "lambda:InvokeFunction"
  function_name = var.lambda_get_coordinates_function_name
  principal     = "apigateway.amazonaws.com"
  statement_id  = "AllowExecutionFromApiGateway"
  source_arn    = "${aws_api_gateway_rest_api.gps_api.execution_arn}/*/*"
}

resource "aws_api_gateway_method_response" "post_gps_response_200" {
  http_method = aws_api_gateway_method.post_gps_method.http_method
  resource_id = aws_api_gateway_resource.post_gps_resource.id
  rest_api_id = aws_api_gateway_rest_api.gps_api.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "post_gps_integration_response_200" {
  http_method = aws_api_gateway_method.post_gps_method.http_method
  resource_id = aws_api_gateway_resource.post_gps_resource.id
  rest_api_id = aws_api_gateway_rest_api.gps_api.id
  status_code = aws_api_gateway_method_response.post_gps_response_200.status_code

  response_templates = {
    "application/json" = jsonencode({
      message = "Success"
    })
  }

  depends_on = [aws_api_gateway_integration.post_gps_kinesis_integration]
}

resource "aws_api_gateway_method_response" "get_gps_response_200" {
  http_method = aws_api_gateway_method.get_gps_method.http_method
  resource_id = aws_api_gateway_resource.get_gps_resource.id
  rest_api_id = aws_api_gateway_rest_api.gps_api.id
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "get_gps_integration_response_200" {
  http_method = aws_api_gateway_method.get_gps_method.http_method
  resource_id = aws_api_gateway_resource.get_gps_resource.id
  rest_api_id = aws_api_gateway_rest_api.gps_api.id
  status_code = aws_api_gateway_method_response.get_gps_response_200.status_code

  depends_on = [aws_api_gateway_integration.get_gps_lambda_integration]
}

resource "aws_api_gateway_deployment" "gps_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.gps_api.id
  depends_on  = [aws_api_gateway_integration.post_gps_kinesis_integration, aws_api_gateway_integration.get_gps_lambda_integration]

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.gps_api.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "gps_api_stage" {
  rest_api_id   = aws_api_gateway_rest_api.gps_api.id
  deployment_id = aws_api_gateway_deployment.gps_api_deployment.id
  stage_name    = var.api_stage_name

  depends_on = [aws_api_gateway_deployment.gps_api_deployment]
}