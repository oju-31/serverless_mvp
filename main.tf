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


# ###########################################
# # LAMBDA MODULES
# ###########################################
# module "lambdas" {
#   source             = "./infra/lambdas"
#   ENV                = var.ENV
#   COMMON_TAGS        = local.COMMON_TAGS
#   USER_TABLE         = module.storage.USER_TABLE_NAME
#   RESOURCE_PREFIX    = local.RESOURCE_PREFIX
#   POOL_ID            = module.web_hosting.COGNITO_USER_POOL_ID
#   CLIENT_ID          = module.web_hosting.COGNITO_USER_CLIENT_ID
#   # CLIENT_SECRET    = module.web_hosting.COGNITO_USER_CLIENT_SECRET
# }


# ############################################
# # Storage and Database
# ############################################
# module "storage" {
#   source          = "./infra/storage"
#   COMMON_TAGS     = local.COMMON_TAGS
#   RESOURCE_PREFIX = local.RESOURCE_PREFIX
# }


# #########################################################
# # Web Hosting
# #########################################################
# module "web_hosting" {
#   source                  = "./infra/web_hosting"
#   ENV                     = var.ENV
#   COMMON_TAGS             = local.COMMON_TAGS
#   WEBAPP_DNS              = var.WEBAPP_DNS
#   ACCOUNT_ID              = local.ACCOUNT_ID
#   WEBAPP_CERT_ID          = var.WEBAPP_CERT_ID
#   RESOURCE_PREFIX         = local.RESOURCE_PREFIX
#   GITHUB_ACTIONS_USER_ARN = var.GITHUB_ACTIONS_USER_ARN
#   ROUTE53_HOSTED_ZONE_NAME = var.ROUTE53_HOSTED_ZONE_NAME
# }
