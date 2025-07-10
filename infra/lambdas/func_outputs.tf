output "LAMBDA_MY_MVP_ENDPOINT" {
  value = aws_lambda_function_url.my_mvp.function_url
}

output "LAMBDA_USER_MNGT_ENDPOINT" {
  value = aws_lambda_function_url.user_mngt.function_url
}
