locals {
  PYTHON_VERSION = "python3.12"
  LAMBDA_VERSION = "v1"
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "COMPUTE"}))
}

# ---------------------------------------------
# SEND_PROMPTS LAMBDA
#----------------------------------------------
resource "aws_lambda_function" "send_prompts" {
  filename         = "${path.root}/backend/zip/send_prompts.zip"
  function_name    = "${var.RESOURCE_PREFIX}-send_prompts-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.send_prompts.arn}"
  handler          = "send_prompts.lambda_handler"
  source_code_hash = data.archive_file.send_prompts.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV       = "${var.ENV}"
      POOL_ID   = "${var.POOL_ID}"
      CLIENT_ID = "${var.CLIENT_ID}"
    }
  }
}
resource "aws_lambda_function_url" "send_prompts" {
  function_name      = aws_lambda_function.send_prompts.function_name
  authorization_type = "NONE"
}
# ------------------------------------------
# GET_TOKEN LAMBDA
#-------------------------------------------
resource "aws_lambda_function" "get_token" {
  filename         = "${path.root}/backend/zip/get_token.zip"
  function_name    = "${var.RESOURCE_PREFIX}-get_token-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.get_token.arn}"
  handler          = "get_token.lambda_handler"
  source_code_hash = data.archive_file.get_token.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV                     = "${var.ENV}"
      HOME_PAGE               = "${var.HOME_PAGE}"
      COGNITO_TOKEN_ENDPOINT  = "https://us-east-1hyef8garn.auth.us-east-1.amazoncognito.com/oauth2/token"
    }
  }
}
resource "aws_lambda_function_url" "get_token" {
  function_name      = aws_lambda_function.get_token.function_name
  authorization_type = "NONE"
}
# ---------------------------------------
# STORE_IMAGES LAMBDA
#----------------------------------------
resource "aws_lambda_function" "store_images" {
  filename         = "${path.root}/backend/zip/store_images.zip"
  function_name    = "${var.RESOURCE_PREFIX}-store_images-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.store_images.arn}"
  handler          = "store_images.lambda_handler"
  source_code_hash = data.archive_file.store_images.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}
resource "aws_lambda_function_url" "store_images" {
  function_name      = aws_lambda_function.store_images.function_name
  authorization_type = "NONE"
}
# ---------------------------------------
# GET_IMAGES LAMBDA
#----------------------------------------
resource "aws_lambda_function" "get_images" {
  filename         = "${path.root}/backend/zip/get_images.zip"
  function_name    = "${var.RESOURCE_PREFIX}-get_images-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.get_images.arn}"
  handler          = "get_images.lambda_handler"
  source_code_hash = data.archive_file.get_images.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}
resource "aws_lambda_function_url" "get_images" {
  function_name      = aws_lambda_function.get_images.function_name
  authorization_type = "NONE"
}
# ---------------------------------------
# GET_ALBUMS LAMBDA
#----------------------------------------
resource "aws_lambda_function" "get_albums" {
  filename         = "${path.root}/backend/zip/get_albums.zip"
  function_name    = "${var.RESOURCE_PREFIX}-get_albums-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.get_albums.arn}"
  handler          = "get_albums.lambda_handler"
  source_code_hash = data.archive_file.get_albums.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}
resource "aws_lambda_function_url" "get_albums" {
  function_name      = aws_lambda_function.get_albums.function_name
  authorization_type = "NONE"
}
# ---------------------------------------
# UPDATE_ALBUM LAMBDA
#----------------------------------------
resource "aws_lambda_function" "update_album" {
  filename         = "${path.root}/backend/zip/update_album.zip"
  function_name    = "${var.RESOURCE_PREFIX}-update_album-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.update_album.arn}"
  handler          = "update_album.lambda_handler"
  source_code_hash = data.archive_file.update_album.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = local.TAGS
  environment {
    variables = {
      ENV           = "${var.ENV}"
    }
  }
}
resource "aws_lambda_function_url" "update_album" {
  function_name      = aws_lambda_function.update_album.function_name
  authorization_type = "NONE"
}