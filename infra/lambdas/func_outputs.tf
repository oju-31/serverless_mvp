output "LAMBDA_LOGIN_ENDPOINT" {
  value = aws_lambda_function_url.login.function_url
}