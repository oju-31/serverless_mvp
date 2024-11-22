locals {
  DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
  RESOURCE_PREFIX     = "${var.ENV}-ahlorq"
  ACCOUNTID           = data.aws_caller_identity.current.account_id
  cognito_domain_name = "auth.${var.WEBAPP_DNS}"
  common_tags         = { 
    Environment = var.ENV 
    Application = "webapp-backend"
    Project     = "smarterise-serverless-backend" 
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
  COMMON_TAGS        = local.common_tags
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  RESOURCE_PREFIX    = local.RESOURCE_PREFIX
  AWS_REGION         = data.aws_region.current.name

  # ROLES ARN
  LAMBDA_LOGIN_ROLE_ARN = module.roles.LAMBDA_LOGIN_ROLE_ARN

  # POOL_ID                                    = module.app_cognito.COGNITO_USER_POOL_ID
  # CLIENT_ID                                  = module.app_cognito.COGNITO_USER_CLIENT_ID
  # CLIENT_SECRET                              = module.app_cognito.COGNITO_USER_CLIENT_SECRET
}


############################################
# IAM ROLE MODULES
############################################
module "roles" {
  source          = "./infra/iam_roles"
  RESOURCE_PREFIX = local.RESOURCE_PREFIX
}


###########################################
# LAMBDA MODULES
###########################################
module "open" {
  source             = "./infra/api_gateways/open_endpoints"
  ENV                = var.ENV
  COMMON_TAGS        = local.common_tags
  CURRENT_ACCOUNT_ID = data.aws_caller_identity.current.account_id
  LAMBDA_NAMES       = [
    module.lambdas.LAMBDA_LOGIN_NAME
    ]
  LAMBDA_LOGIN_ARN   = module.lambdas.LAMBDA_LOGIN_ARN
  
  depends_on         = [
      module.roles, 
      module.lambdas
    ]

}