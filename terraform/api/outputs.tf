output "api_id" {
  value = aws_api_gateway_rest_api.gps_api.id
}

output "api_stage" {
  value = aws_api_gateway_stage.gps_api_stage.stage_name
}