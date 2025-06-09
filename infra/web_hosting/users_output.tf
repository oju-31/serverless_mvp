output "COGNITO_USER_POOL_ARN"{
  value = "${aws_cognito_user_pool.ahlorq_users.arn}"
}

output "COGNITO_USER_POOL_ID"{
  value = "${aws_cognito_user_pool.ahlorq_users.id}"
}

output "COGNITO_USER_CLIENT_ID"{
  value = "${aws_cognito_user_pool_client.ahlorq_ui.id}"
}

output "S3_FRONTEND_BUCKET_NAME" {
  value = aws_s3_bucket.ahlorq_frontend.id
  description = "This is used to sync frontend with the s3 website bucket."
}

output "nameservers" {
  value = aws_route53_zone.ahlorq_zone.name_servers
}