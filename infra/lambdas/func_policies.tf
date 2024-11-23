################################################################################
 # LAMBDA OPEN POLICIES
################################################################################
resource "aws_iam_role_policy" "lambda_login" {
  name = "${var.RESOURCE_PREFIX}-lambda-login-policy"
  role = aws_iam_role.lambda_login.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "*",
        Resource = [
          "*"
        ]
      }
    ]
  })
}
