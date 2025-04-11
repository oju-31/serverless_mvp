variable "ENV" {
    type = string
}

# variable "ROUTE53_HOSTED_ZONE_NAME" {
#     type = string
# }

# variable "WEBAPP_DNS" {
#     type = string
# }

variable "COGNITO_USER_POOL_ID" {
    type = string
}

variable "COGNITO_CLIENT_ID" {
    type = string
}

variable "GITHUB_ACTIONS_USER_ARN" {
    type = string
}

variable "AWS_REGION" {
    type = string
    default = "us-east-1"
}

locals {
  # DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
  RESOURCE_PREFIX     = "${var.ENV}-ahlorq-style-gen"
  ACCOUNTID           = data.aws_caller_identity.current.account_id
  FRONTEND_FILES = fileset("${path.root}/frontend", "**")
  PYTHON_VERSION = "python3.12"
  LAMBDA_VERSION = "v1"
  HOME_PAGE          = "https://${module.static.CLOUDFRONT_DOMAIN_NAME}"
  # cognito_domain_name = "auth.${var.WEBAPP_DNS}"
  COMMON_TAGS          = { 
    Environment = var.ENV 
    Application = "webapp-serverless"
    Project     = "ahlorq ai style generator" 
    Owner       = "aojutomori@gmail.com"
    CostCenter  = "WEBAPP-SERVERLESS-${var.ENV}-001"
  } 
}