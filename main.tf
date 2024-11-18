locals {
  DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
  RESOURCE_PREFIX     = "${var.ENV}-smarterise"
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

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-example-bucket-999234"
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
  source          = "./infra/api_gateways/open_endpoints"
  ENV             = var.ENV
  COMMON_TAGS     = local.common_tags
  CURRENT_ACCOUNT_ID       = local.ACCOUNTID
  API_DOMAIN_NAME = module.custom_domain.API_DOMAIN_NAME
  LAMBDA_NAMES = [
    module.lambda.LAMBDA_SIGNUP_NAME,
    module.lambda.LAMBDA_CONTACT_US_NAME,
    module.lambda.LAMBDA_LOGIN_NAME,
    module.lambda.LAMBDA_CONFIRM_SIGNUP_NAME,
    module.lambda.LAMBDA_RESEND_VERIFY_CODE_NAME,
    module.lambda.LAMBDA_CHANGE_PASSWORD_NAME,
    module.lambda.LAMBDA_FORGOT_PASSWORD_NAME,
    module.lambda.LAMBDA_CONFIRM_FORGOT_PASSWORD_NAME,
    module.lambda.LAMBDA_REFRESH_TOKEN_NAME,
    module.lambda.LAMBDA_RANKING_NAME

    ]
  LAMBDA_SIGNUP_ARN  = module.lambda.LAMBDA_SIGNUP_ARN
  LAMBDA_SIGNUP_NAME = module.lambda.LAMBDA_SIGNUP_NAME
  LAMBDA_SIGNUP_ROLE_ARN    = module.role.LAMBDA_SIGNUP_ROLE_ARN
  
  LAMBDA_REFRESH_TOKEN_ARN  = module.lambda.LAMBDA_REFRESH_TOKEN_ARN
  LAMBDA_REFRESH_TOKEN_NAME = module.lambda.LAMBDA_REFRESH_TOKEN_NAME
  LAMBDA_REFRESH_TOKEN_ROLE_ARN    = module.role.LAMBDA_REFRESH_TOKEN_ROLE_ARN
  
  LAMBDA_CONFIRM_SIGNUP_ARN  = module.lambda.LAMBDA_CONFIRM_SIGNUP_ARN
  LAMBDA_CONFIRM_SIGNUP_NAME = module.lambda.LAMBDA_CONFIRM_SIGNUP_NAME
  LAMBDA_CONFIRM_SIGNUP_ROLE_ARN    = module.role.LAMBDA_CONFIRM_SIGNUP_ROLE_ARN
  
  LAMBDA_LOGIN_ARN  = module.lambda.LAMBDA_LOGIN_ARN
  LAMBDA_LOGIN_NAME = module.lambda.LAMBDA_LOGIN_NAME
  LAMBDA_LOGIN_ROLE_ARN    = module.role.LAMBDA_LOGIN_ROLE_ARN
  
  LAMBDA_RESEND_VERIFY_CODE_ARN  = module.lambda.LAMBDA_RESEND_VERIFY_CODE_ARN
  LAMBDA_RESEND_VERIFY_CODE_NAME = module.lambda.LAMBDA_RESEND_VERIFY_CODE_NAME
  LAMBDA_RESEND_VERIFY_CODE_ROLE_ARN    = module.role.LAMBDA_RESEND_VERIFY_CODE_ROLE_ARN
  
  LAMBDA_CONTACT_US_ARN  = module.lambda.LAMBDA_CONTACT_US_ARN
  LAMBDA_CONTACT_US_NAME = module.lambda.LAMBDA_CONTACT_US_NAME
  LAMBDA_CONTACT_US_ROLE_ARN    = module.role.LAMBDA_CONTACT_US_ROLE_ARN
  
  LAMBDA_CHANGE_PASSWORD_ARN  = module.lambda.LAMBDA_CHANGE_PASSWORD_ARN
  LAMBDA_CHANGE_PASSWORD_NAME = module.lambda.LAMBDA_CHANGE_PASSWORD_NAME
  LAMBDA_CHANGE_PASSWORD_ROLE_ARN    = module.role.LAMBDA_CHANGE_PASSWORD_ROLE_ARN
  
  LAMBDA_FORGOT_PASSWORD_ARN  = module.lambda.LAMBDA_FORGOT_PASSWORD_ARN
  LAMBDA_FORGOT_PASSWORD_NAME = module.lambda.LAMBDA_FORGOT_PASSWORD_NAME
  LAMBDA_FORGOT_PASSWORD_ROLE_ARN    = module.role.LAMBDA_FORGOT_PASSWORD_ROLE_ARN
  
  LAMBDA_CONFIRM_FORGOT_PASSWORD_ARN  = module.lambda.LAMBDA_CONFIRM_FORGOT_PASSWORD_ARN
  
  LAMBDA_RANKING_ARN  = module.lambda.LAMBDA_RANKING_ARN
  LAMBDA_RANKING_NAME = module.lambda.LAMBDA_RANKING_NAME
  LAMBDA_RANKING_ROLE_ARN    = module.role.LAMBDA_RANKING_ROLE_ARN
  
  depends_on = [
      module.roles,
      module.lambdas
    ]

}