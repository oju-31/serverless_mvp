variable "ENV" {}
variable "COMMON_TAGS" {}
variable "WEBAPP_DNS" {}
variable "ACCOUNT_ID" {}
variable "AWS_REGION" {}
variable "WEBAPP_CERT_ID" {}
variable "RESOURCE_PREFIX" {}
variable "GITHUB_ACTIONS_USER_ARN" {}
variable "ROUTE53_HOSTED_ZONE_NAME" {}
locals {
  FRONTEND_FILES = fileset("${path.root}/frontend", "**")
  ALIASSES = [var.WEBAPP_DNS, "www.${var.WEBAPP_DNS}"]
}
