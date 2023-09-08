output "post_gps_api_url" {
  value = "${module.route53.gps_api_url}/${var.api_post_resource_path}"
}

output "get_gps_api_url" {
  value = "${module.route53.gps_api_url}/${var.api_get_resource_path}"
}