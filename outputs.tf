#-------------------------------
#  API ENDPOINTS
#-------------------------------
output "environment_label" {
  description = "Environment label"
  value       = var.ENV == "dev" ? "These are Development URLs" : "These are Production URLs"
}

output "USER_MNGT_ENDPOINT" {
  value = module.lambdas.LAMBDA_USER_MNGT_ENDPOINT
}

output "MY_MVP_ENDPOINT" {
  value = module.lambdas.LAMBDA_MY_MVP_ENDPOINT
}

output "CLOUDFRONT_DOMAIN_NAME" {
  value = module.web_hosting.CLOUDFRONT_DOMAIN_NAME
}
