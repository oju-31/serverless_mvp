locals {
  # DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
  RESOURCE_PREFIX     = "${var.ENV}-ahlorq"
  ACCOUNT_ID          = data.aws_caller_identity.current.account_id

  # cognito_domain_name = "auth.${var.WEBAPP_DNS}"
  COMMON_TAGS          = { 
    Environment = var.ENV 
    Application = "serverless-webapp"
    Project     = "style generation sewing guide and store" 
    Owner       = "aojutomori@gmail.com"
    CostCenter  = "SERVERLESS-WEBAPP${var.ENV}-001"
  } 
}


###########################################
# LAMBDA MODULES
###########################################
module "lambdas" {
  source             = "./infra/lambdas"
  ENV                = var.ENV
  COMMON_TAGS        = local.COMMON_TAGS
  USER_TABLE         = module.storage.USER_TABLE_NAME
  RESOURCE_PREFIX    = local.RESOURCE_PREFIX
  POOL_ID            = module.web_hosting.COGNITO_USER_POOL_ID
  CLIENT_ID          = module.web_hosting.COGNITO_USER_CLIENT_ID
  # CLIENT_SECRET    = module.web_hosting.COGNITO_USER_CLIENT_SECRET
}


############################################
# Storage and Database
############################################
module "storage" {
  source          = "./infra/storage"
  COMMON_TAGS     = local.COMMON_TAGS
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
}


#########################################################
# Web Hosting
#########################################################
module "web_hosting" {
  source                  = "./infra/web_hosting"
  ENV                     = var.ENV
  COMMON_TAGS             = local.COMMON_TAGS
  WEBAPP_DNS              = var.WEBAPP_DNS
  ACCOUNT_ID              = local.ACCOUNT_ID
  WEBAPP_CERT_ID          = var.WEBAPP_CERT_ID
  RESOURCE_PREFIX         = local.RESOURCE_PREFIX
  GITHUB_ACTIONS_USER_ARN = var.GITHUB_ACTIONS_USER_ARN
  ROUTE53_HOSTED_ZONE_NAME = var.ROUTE53_HOSTED_ZONE_NAME
}


# ####################################################################################################################################################################
# #  COGNITO
# ##########################################################################################################################
# resource "aws_cognito_user_pool" "ahlorq_users" {
#   name = "${local.RESOURCE_PREFIX}-userpool"
#   auto_verified_attributes = ["email"]
#   username_attributes = ["email"]

#   password_policy {
#     minimum_length = 8
#     require_uppercase = true
#     require_lowercase = true
#     require_numbers   = true
#     require_symbols   = false
#   }
# }

# resource "aws_cognito_user_pool_client" "ahlorq_ui" {
#   name         ="${local.RESOURCE_PREFIX}-web-client"
#   user_pool_id = aws_cognito_user_pool.ahlorq_users.id

#   generate_secret = false

#   allowed_oauth_flows_user_pool_client = true

#   allowed_oauth_flows = ["code", "implicit"]
#   allowed_oauth_scopes = ["openid", "email", "profile"]

#   callback_urls = ["https://${aws_cloudfront_distribution.website_cdn.domain_name}"]
#   logout_urls = ["https://${aws_cloudfront_distribution.website_cdn.domain_name}/about"]

#   supported_identity_providers = ["COGNITO"]

#   explicit_auth_flows = [
#     "ALLOW_USER_PASSWORD_AUTH",
#     "ALLOW_REFRESH_TOKEN_AUTH",
#     "ALLOW_USER_SRP_AUTH",
#     "ALLOW_CUSTOM_AUTH",
#     "ALLOW_ADMIN_USER_PASSWORD_AUTH"
#   ]
# }
