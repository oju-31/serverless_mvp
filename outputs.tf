output "S3_FRONTEND_BUCKET_NAME" {
  value = module.static.S3_FRONTEND_BUCKET_NAME
}

output "COGNITO_LOGIN_URL" {
  description = <<EOT
Two things to note here, makesure the poolid and the cliend id 
matches the one on your tvars. The poolid is the one right after https://.
Also, ??the CLOUDFRONT_DOMAIN_NAME output returns a url without https
preceding, so that has been done with the slashes escaped
EOT
  value = "https://us-east-1uxrlifhg5.auth.us-east-1.amazoncognito.com/login?client_id=3t0ddf7eo26rhtm56q982v9a0p&response_type=code&scope=email+openid+phone&redirect_uri=https%3A%2F%2F${module.static.CLOUDFRONT_DOMAIN_NAME}"
}

#-------------------------------
#  API ENDPOINTS
#-------------------------------

output "LOGIN_ENDPOINT" {
  value = module.lambdas.LAMBDA_LOGIN_ENDPOINT
}
