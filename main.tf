locals {
  DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
  RESOURCE_PREFIX     = "${var.ENV}-ahlorq-style-gen"
  ACCOUNTID           = data.aws_caller_identity.current.account_id
  cognito_domain_name = "auth.${var.WEBAPP_DNS}"
  COMMON_TAGS          = { 
    Environment = var.ENV 
    Application = "webapp-serverless"
    Project     = "ahlorq ai style generator" 
    Owner       = "aojutomori@gmail.com"
    CostCenter  = "WEBAPP-SERVERLESS-${var.ENV}-001"
  } 
}


###########################################
# LAMBDA MODULES
###########################################
module "lambdas" {
  source             = "./infra/lambdas"
  ENV                = var.ENV
  COMMON_TAGS        = local.COMMON_TAGS
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  RESOURCE_PREFIX    = local.RESOURCE_PREFIX
  AWS_REGION         = data.aws_region.current.name

  # POOL_ID                                    = module.app_cognito.COGNITO_USER_POOL_ID
  # CLIENT_ID                                  = module.app_cognito.COGNITO_USER_CLIENT_ID
  # CLIENT_SECRET                              = module.app_cognito.COGNITO_USER_CLIENT_SECRET
}


############################################
# DYNAMODB
############################################
############################################
# STATIC WEB HOSTING
############################################
module "static" {
  source             = "./infra/web_hosting"
  ENV                = var.ENV
  COMMON_TAGS        = local.COMMON_TAGS
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  RESOURCE_PREFIX    = local.RESOURCE_PREFIX
  AWS_REGION         = data.aws_region.current.name
}
