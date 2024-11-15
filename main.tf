locals {
  DOMAIN_NAME         = "api.${var.WEBAPP_DNS}"
  RESOURCE_PREFIX     = "${var.ENV}-smarterise"
  ACCOUNTID           = data.aws_caller_identity.current.account_id
  cognito_domain_name = lower(var.ENV) == "prod" ? "auth.${var.WEBAPP_DNS}" : "auth.${var.WEBAPP_DNS}"
  common_tags         = { 
    environment = var.ENV 
    project     = "smarterise-webapp" 
    managedby   = "aojutomori@gmail.com"
    application = "webapp-backend"
  } 
}

resource "aws_s3_bucket" "example" {
  bucket = "my-tf-example-bucket-999234"
}