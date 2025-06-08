locals {
  PYTHON_VERSION = "python3.12"
  LAMBDA_VERSION = "v1"
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "COMPUTE"}))
}

# ---------------------------------------------
# SEWING GUIDES LAMBDA
#----------------------------------------------
resource "aws_lambda_function" "sewing_guides" {
  filename         = "${path.root}/backend/zip/sewing_guides.zip"
  function_name    = "sewing_guides-${var.RESOURCE_PREFIX}-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.sewing_guides.arn}"
  handler          = "guides.lambda_handler"
  source_code_hash = data.archive_file.sewing_guides.output_base64sha256
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

resource "aws_lambda_function_url" "sewing_guides" {
  function_name      = aws_lambda_function.sewing_guides.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"] # update to ahlorq domain
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# ---------------------------------------------
# STORE MNGT LAMBDA
#----------------------------------------------
resource "aws_lambda_function" "store_mngt" {
  filename         = "${path.root}/backend/zip/store_mngt.zip"
  function_name    = "store_mngt-${var.RESOURCE_PREFIX}-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.store_mngt.arn}"
  handler          = "store.lambda_handler"
  source_code_hash = data.archive_file.store_mngt.output_base64sha256
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

resource "aws_lambda_function_url" "store_mngt" {
  function_name      = aws_lambda_function.store_mngt.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"] 
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# ---------------------------------------------
# STYLE GENERATIONS LAMBDA
#----------------------------------------------
resource "aws_lambda_function" "style_generations" {
  filename         = "${path.root}/backend/zip/style_generations.zip"
  function_name    = "style_generations-${var.RESOURCE_PREFIX}-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.style_generations.arn}"
  handler          = "styles.lambda_handler"
  source_code_hash = data.archive_file.style_generations.output_base64sha256
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

resource "aws_lambda_function_url" "style_generations" {
  function_name      = aws_lambda_function.style_generations.function_name
  authorization_type = "NONE"
  cors {
    allow_credentials = true
    allow_origins     = ["*"]
    allow_methods     = ["*"]
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}

# ---------------------------------------------
# USER MNGT LAMBDA
#----------------------------------------------
resource "aws_lambda_function" "user_mngt" {
  filename         = "${path.root}/backend/zip/user_mngt.zip"
  function_name    = "user_mngt-${var.RESOURCE_PREFIX}-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.user_mngt.arn}"
  handler          = "auth.lambda_handler"
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
    allow_headers     = ["date", "keep-alive", "content-type"]
    expose_headers    = ["keep-alive", "date"]
    max_age           = 86400
  }
}