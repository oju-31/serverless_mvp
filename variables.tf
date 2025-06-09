variable "ENV" {
    type = string
}

variable "ROUTE53_HOSTED_ZONE_NAME" {
    type = string
    default = "ahlorq.com"
}

variable "WEBAPP_DNS" {
    type = string
}

variable "WEBAPP_CERT_ID" {
    type = string
    default = "b03f50c5-55d1-4caa-a24f-fa63d5403aca"
}

variable "GITHUB_ACTIONS_USER_ARN" {
    type = string
    default = "arn:aws:iam::572977324971:user/github-actions-terraform-deployment"
}

variable "AWS_REGION" {
    type = string
}

# locals {
#   # DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
#   RESOURCE_PREFIX     = "${var.ENV}-ahlorq-style-gen"
#   ACCOUNTID           = data.aws_caller_identity.current.account_id
#   FRONTEND_FILES = fileset("${path.root}/frontend", "**")
#   PYTHON_VERSION = "python3.12"
#   LAMBDA_VERSION = "v1"
# #   HOME_PAGE          = "https://${module.static.CLOUDFRONT_DOMAIN_NAME}"
#   # cognito_domain_name = "auth.${var.WEBAPP_DNS}"
#   COMMON_TAGS          = { 
#     Environment = var.ENV 
#     Application = "webapp-serverless"
#     Project     = "ahlorq ai style generator" 
#     Owner       = "aojutomori@gmail.com"
#     CostCenter  = "WEBAPP-SERVERLESS-${var.ENV}-001"
#   } 
# }