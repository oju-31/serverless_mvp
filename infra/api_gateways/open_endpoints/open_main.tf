data "template_file" api_swagger{
  template = "${file("${path.module}/swagger/swagger.yml")}"
     vars = {
        LAMBDA_LOGIN_ARN = "${var.LAMBDA_LOGIN_ARN}"

        LAMBDA_SIGNUP_ARN = "${var.LAMBDA_SIGNUP_ARN}"
        LAMBDA_RESEND_VERIFY_CODE_ARN = "${var.LAMBDA_RESEND_VERIFY_CODE_ARN}"       
        LAMBDA_CONTACT_US_ARN = "${var.LAMBDA_CONTACT_US_ARN}"
        LAMBDA_CONFIRM_SIGNUP_ARN = "${var.LAMBDA_CONFIRM_SIGNUP_ARN}"       
        LAMBDA_CHANGE_PASSWORD_ARN = "${var.LAMBDA_CHANGE_PASSWORD_ARN}"
        LAMBDA_FORGOT_PASSWORD_ARN = "${var.LAMBDA_FORGOT_PASSWORD_ARN}"
        LAMBDA_CONFIRM_FORGOT_PASSWORD_ARN = "${var.LAMBDA_CONFIRM_FORGOT_PASSWORD_ARN}"
        
        ACCOUNTID = "${var.CURRENT_ACCOUNT_ID }"
        ENV  = "${var.ENV}"
        basePath  = "${var.ENV}"
    }
}

resource "aws_api_gateway_rest_api" "api_gateway" {
  description  = "pgraters-${var.RESOURCE_PREFIX} Rest API Gateway for pgraters accountant in ${var.ENV} environment."
  name = "${var.ENV}-pgraters-${var.RESOURCE_PREFIX}-api_rest_api"
  body = data.template_file.api_swagger.rendered
  disable_execute_api_endpoint = true
}

resource "aws_api_gateway_base_path_mapping" "api_domain_map" {
  api_id      = aws_api_gateway_rest_api.api_gateway.id
  domain_name = var.API_DOMAIN_NAME
  stage_name = aws_api_gateway_stage.pgraters_stages.stage_name
  base_path = var.RESOURCE_PREFIX
}

resource "aws_api_gateway_deployment" "pgraters_deployment" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  lifecycle {
    create_before_destroy = true
  }
  
  depends_on = [
    aws_api_gateway_rest_api_policy.pgraters_api_policy,
    aws_lambda_permission.lambda_permissions
  ]
  
  variables = {
    "deployed_at" = "${timestamp()}"
  }
}


resource "aws_api_gateway_stage" "pgraters_stages" {
  deployment_id = aws_api_gateway_deployment.pgraters_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.api_gateway.id
  stage_name    = var.ENV
}


resource "aws_api_gateway_rest_api_policy" "pgraters_api_policy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": "*",
      "Action": "execute-api:Invoke",
      "Resource": [
        "${aws_api_gateway_rest_api.api_gateway.execution_arn}",
        "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*"
      ]
    }
  ]
}
EOF
}



################################################################################
# Permissions - Lambda(s)
################################################################################

resource "aws_lambda_permission" "lambda_permissions" {
  count = length(var.LAMBDA_NAMES)
  function_name = var.LAMBDA_NAMES[count.index]
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn = "${aws_api_gateway_rest_api.api_gateway.execution_arn}/*/*"
  depends_on = [
    aws_api_gateway_rest_api.api_gateway
  ]
}