# ---------------------------------------------
# USER MNGT LAMBDA
#----------------------------------------------
resource "aws_lambda_function" "user_mngt" {
  filename         = "${path.root}/backend/zip/user_mngt.zip"
  function_name    = "user_mngt-${var.RESOURCE_PREFIX}-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.user_mngt.arn}"
  handler          = "A1_user_mngt.lambda_handler"
  source_code_hash = data.archive_file.user_mngt.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV        = "${var.ENV}"
      POOL_ID    = "${var.POOL_ID}"
      CLIENT_ID  = "${var.CLIENT_ID}"
      USER_TABLE = "${var.USER_TABLE}"
    }
  }
}

resource "aws_lambda_function_url" "user_mngt" {
  function_name      = aws_lambda_function.user_mngt.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"] 
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive", "content-type", "authorization", "Authorization"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# ---------------------------------------------
# MY MVP LAMBDA
#----------------------------------------------
resource "aws_lambda_function" "my_mvp" {
  filename         = "${path.root}/backend/zip/my_mvp.zip"
  function_name    = "my_mvp-${var.RESOURCE_PREFIX}-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.my_mvp.arn}"
  handler          = "A1_my_mvp.lambda_handler"
  source_code_hash = data.archive_file.my_mvp.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV        = "${var.ENV}"
      POOL_ID    = "${var.POOL_ID}"
      CLIENT_ID  = "${var.CLIENT_ID}"
      USER_TABLE = "${var.USER_TABLE}"
    }
  }
}

resource "aws_lambda_function_url" "my_mvp" {
  function_name      = aws_lambda_function.my_mvp.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive", "content-type", "authorization", "Authorization"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}
