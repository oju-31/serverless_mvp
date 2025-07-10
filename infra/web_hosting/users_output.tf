output "COGNITO_USER_POOL_ARN"{
  value = "${aws_cognito_user_pool.users_mngt.arn}"
}

output "COGNITO_USER_POOL_ID"{
  value = "${aws_cognito_user_pool.users_mngt.id}"
}

output "COGNITO_USER_CLIENT_ID"{
  value = "${aws_cognito_user_pool_client.client_ui.id}"
}

output "CLOUDFRONT_DOMAIN_NAME" {
  value = "${aws_cloudfront_distribution.cdn.domain_name}"
}
