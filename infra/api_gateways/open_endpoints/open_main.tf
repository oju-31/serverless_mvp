data "template_file" api_swagger{
  template = "${file("${path.module}/swaggers/open_swagger.yml")}"
     vars = {
        LAMBDA_LOGIN_ARN = "${var.LAMBDA_LOGIN_ARN}"
        ACCOUNTID        = "${var.CURRENT_ACCOUNT_ID }"
        ENV              = "${var.ENV}"
        basePath         = "${var.RESOURCE_PREFIX}"
    }
}

resource "aws_api_gateway_rest_api" "open_rest_apis" {
  description  = "ahlorq style generator Rest APIs for pgraters open endpoint in ${var.ENV} environment."
  name = "${var.ENV}-style-generator-${var.RESOURCE_PREFIX}-rest-api"
  body = data.template_file.api_swagger.rendered
  disable_execute_api_endpoint = true
}

resource "aws_api_gateway_deployment" "open_api_deployment" {
  rest_api_id = aws_api_gateway_rest_api.open_rest_apis.id
  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.open_rest_apis.body))
  }
  depends_on = [
    aws_lambda_permission.open_apis_stage
  ]
  
  variables = {
    "deployed_at" = "${timestamp()}"
  }
  lifecycle {
    create_before_destroy = true
  }
} 


resource "aws_api_gateway_stage" "open_apis_stage" {
  deployment_id = aws_api_gateway_deployment.open_api_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.open_rest_apis.id
  stage_name    = var.ENV
}


################################################################################
# Permissions - Lambda(s)
################################################################################

resource "aws_lambda_permission" "open_lambda_permissions" {
  count = length(var.LAMBDA_NAMES)
  function_name = var.LAMBDA_NAMES[count.index]
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.open_rest_apis.execution_arn}/*/*"
  depends_on     = [aws_api_gateway_rest_api.open_rest_apis]
}