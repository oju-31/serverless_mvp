# ---------------------------------------------
# OPEN MODULE
#----------------------------------------------
resource "aws_lambda_function" "lambda_login" {
  filename         = "${path.root}/backend/open/zip/signup.zip"
  function_name    = "${var.RESOURCE_PREFIX}-login-${local.LAMBDA_VERSION}"
  role             = var.LAMBDA_LOGIN_ROLE_ARN
  handler          = "login.lambda_handler"
  source_code_hash = data.archive_file.lambda_login_archive.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300

  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}