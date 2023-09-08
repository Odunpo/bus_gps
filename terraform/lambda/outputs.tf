output "lambda_consumer_invoke_arn" {
  value = aws_lambda_function.lambda_consumer.invoke_arn
}

output "lambda_consumer_function_name" {
  value = aws_lambda_function.lambda_consumer.function_name
}

output "lambda_get_coordinates_invoke_arn" {
  value = aws_lambda_function.lambda_get_coordinates.invoke_arn
}

output "lambda_get_coordinates_function_name" {
  value = aws_lambda_function.lambda_get_coordinates.function_name
}