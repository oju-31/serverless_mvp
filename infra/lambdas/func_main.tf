locals {
  PYTHON_VERSION = "python3.12"
  LAMBDA_VERSION = "v1"
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "COMPUTE"}))
}


# ---------------------------------------------
# OPEN MODULE
#----------------------------------------------
resource "aws_lambda_function" "lambda_login" {
  filename         = "${path.root}/backend/open/zip/login.zip"
  function_name    = "${var.RESOURCE_PREFIX}-login-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.lambda_login.arn}"
  handler          = "login.lambda_handler"
  source_code_hash = data.archive_file.lambda_login_archive.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS

  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}

resource "aws_lambda_function_url" "lambda_login" {
  function_name      = aws_lambda_function.lambda_login.function_name
  authorization_type = "NONE"
}