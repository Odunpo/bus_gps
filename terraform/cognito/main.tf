resource "aws_cognito_user_pool" "gps_user_pool" {
  name = var.cognito_user_pool_name

  admin_create_user_config {
    allow_admin_create_user_only = true
  }
}

resource "aws_cognito_user_pool_client" "gps_user_pool_client" {
  name                                 = var.cognito_user_pool_client_name
  user_pool_id                         = aws_cognito_user_pool.gps_user_pool.id
  callback_urls                        = ["https://example.com/callback"]
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows                  = ["code", "implicit"]
  allowed_oauth_scopes                 = ["email", "openid"]
  supported_identity_providers         = ["COGNITO"]
  explicit_auth_flows                  = ["ALLOW_CUSTOM_AUTH", "ALLOW_REFRESH_TOKEN_AUTH", "ALLOW_USER_PASSWORD_AUTH", "ALLOW_USER_SRP_AUTH"]
}

resource "random_pet" "domain_name" {
  prefix = "gps-bus"
  length = 4
}

resource "aws_cognito_user_pool_domain" "gps_domain" {
  domain       = random_pet.domain_name.id
  user_pool_id = aws_cognito_user_pool.gps_user_pool.id
}