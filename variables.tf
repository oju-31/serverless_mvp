variable "ENV" {
    type = string
}

variable "AWS_REGION" {
    type = string
}

variable "APP_NAME" {
    type = string
    default = "my-app"  # no spaces, no special characters
}

locals {
  RESOURCE_PREFIX = "${var.ENV}-${var.APP_NAME}" 
  ACCOUNT_ID      = data.aws_caller_identity.current.account_id

  COMMON_TAGS          = { 
    Environment = var.ENV 
    Application = "serverless-webapp"
    Project     = "add description here" 
    Owner       = "youremalhere@gmail.com"
    CostCenter  = "SERVERLESS-WEBAPP-${var.ENV}-${var.APP_NAME}"
  } 
}