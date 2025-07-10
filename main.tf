locals {
  RESOURCE_PREFIX = "${var.ENV}-compa" #no spaces, no special characters, no uppercase letters
  APP_NAME        = "your app name here" # this is used in email sent to users
  ACCOUNT_ID      = data.aws_caller_identity.current.account_id

  COMMON_TAGS          = { 
    Environment = var.ENV 
    Application = "serverless-webapp"
    Project     = "add description here" 
    Owner       = "youremalhere@gmail.com"
    CostCenter  = "SERVERLESS-WEBAPP-${var.ENV}-001"
  } 
}


# ###########################################
# # LAMBDA MODULES
# ###########################################
# module "lambdas" {
#   source           = "./infra/lambdas"
#   ENV              = var.ENV
#   COMMON_TAGS      = local.COMMON_TAGS
#   USER_TABLE       = module.storage.USER_TABLE_NAME
#   RESOURCE_PREFIX  = local.RESOURCE_PREFIX
#   POOL_ID          = module.web_hosting.COGNITO_USER_POOL_ID
#   CLIENT_ID        = module.web_hosting.COGNITO_USER_CLIENT_ID
#   COGNITO_POOL_ARN = module.web_hosting.COGNITO_USER_POOL_ARN
#   USER_TABLE_ARN   = module.storage.USER_TABLE_ARN
# }


# ############################################
# # Storage and Database
# ############################################
# module "storage" {
#   source          = "./infra/storage"
#   COMMON_TAGS     = local.COMMON_TAGS
#   RESOURCE_PREFIX = local.RESOURCE_PREFIX
#   ENV             = var.ENV
# }


# #########################################################
# # Web Hosting
# #########################################################
# module "web_hosting" {
#   source          = "./infra/web_hosting"
#   ENV             = var.ENV
#   COMMON_TAGS     = local.COMMON_TAGS
#   APP_NAME        = local.APP_NAME
#   RESOURCE_PREFIX = local.RESOURCE_PREFIX
# }
