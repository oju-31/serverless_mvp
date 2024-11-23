# --------------------------------------
# LOGIN POLICY
#---------------------------------------
resource "aws_iam_role_policy" "login" {
  name = "${var.RESOURCE_PREFIX}-lambda-login-policy"
  role = aws_iam_role.login.id

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


# -------------------------------------------------
# GENERATE PROMPTS POLICY
#--------------------------------------------------
resource "aws_iam_role_policy" "generate_prompts" {
  name = "${var.RESOURCE_PREFIX}-lambda-generate-prompts-policy"
  role = aws_iam_role.generate_prompts.id

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