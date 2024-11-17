output "LAMBDA_LOGIN_ROLE_ARN" {
  value = "${aws_iam_role.lambda_login.arn}"
}
output "LAMBDA_SIGNUP_LOGIN_NAME" {
  value = "${aws_iam_role.lambda_login.name}"
}