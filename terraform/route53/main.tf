resource "aws_apigatewayv2_domain_name" "api" {
  domain_name = var.custom_domain_name

  domain_name_configuration {
    certificate_arn = aws_acm_certificate.api.arn
    endpoint_type   = "REGIONAL"
    security_policy = "TLS_1_2"
  }

  depends_on = [aws_acm_certificate_validation.api]
}

resource "aws_route53_record" "api" {
  name    = aws_apigatewayv2_domain_name.api.domain_name
  type    = "A"
  zone_id = data.aws_route53_zone.public.zone_id

  alias {
    name                   = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].target_domain_name
    zone_id                = aws_apigatewayv2_domain_name.api.domain_name_configuration[0].hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_api_gateway_base_path_mapping" "post_api" {
  api_id      = var.post_coordinates_api_id
  domain_name = aws_apigatewayv2_domain_name.api.domain_name
  stage_name  = var.post_coordinates_api_stage
}