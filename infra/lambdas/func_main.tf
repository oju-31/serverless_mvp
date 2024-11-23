locals {
  PYTHON_VERSION = "python3.12"
  LAMBDA_VERSION = "v1"
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "COMPUTE"}))
}


# ---------------------------------------
# LOGIN 
#----------------------------------------
resource "aws_lambda_function" "login" {
  filename         = "${path.root}/backend/open/zip/login.zip"
  function_name    = "${var.RESOURCE_PREFIX}-login-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.login.arn}"
  handler          = "login.lambda_handler"
  source_code_hash = data.archive_file.login.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS

  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}

resource "aws_lambda_function_url" "login" {
  function_name      = aws_lambda_function.login.function_name
  authorization_type = "NONE"
}


# ---------------------------------------
# GENERATE PROMPTS 
#----------------------------------------
resource "aws_lambda_function" "generate_prompts" {
  filename         = "${path.root}/backend/generators/zip/generate_prompts.zip"
  function_name    = "${var.RESOURCE_PREFIX}-generate-prompts-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.generate_prompts.arn}"
  handler          = "generate_prompts.lambda_handler"
  source_code_hash = data.archive_file.generate_prompts.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS

  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}

resource "aws_lambda_function_url" "generate_prompts" {
  function_name      = aws_lambda_function.generate_prompts.function_name
  authorization_type = "NONE"
}