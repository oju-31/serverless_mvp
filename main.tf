###########################################
# LAMBDA MODULES
###########################################
module "lambdas" {
  source           = "./infra/lambdas"
  ENV              = var.ENV
  COMMON_TAGS      = local.COMMON_TAGS
  USER_TABLE       = module.storage.USER_TABLE_NAME
  RESOURCE_PREFIX  = local.RESOURCE_PREFIX
  POOL_ID          = module.web_hosting.COGNITO_USER_POOL_ID
  CLIENT_ID        = module.web_hosting.COGNITO_USER_CLIENT_ID
  COGNITO_POOL_ARN = module.web_hosting.COGNITO_USER_POOL_ARN
  USER_TABLE_ARN   = module.storage.USER_TABLE_ARN
}


############################################
# Storage and Database
############################################
module "storage" {
  source          = "./infra/storage"
  COMMON_TAGS     = local.COMMON_TAGS
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
  ENV             = var.ENV
}


#########################################################
# Web Hosting
#########################################################
module "web_hosting" {
  source          = "./infra/web_hosting"
  ENV             = var.ENV
  COMMON_TAGS     = local.COMMON_TAGS
  APP_NAME        = var.APP_NAME
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
}
