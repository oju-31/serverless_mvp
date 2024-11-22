output "LAMBDA_LOGIN_NAME" {
  value = aws_lambda_function.lambda_login.function_name
}
output "LAMBDA_LOGIN_ARN" {
  value = aws_lambda_function.lambda_login.arn
}
# output "LAMBDA_LOGIN_INVOKE_ARN" {
#   value = aws_lambda_function.lambda_login.invoke_arn
# }
