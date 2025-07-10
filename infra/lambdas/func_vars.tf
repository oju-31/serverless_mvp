variable "ENV" {}
variable "COMMON_TAGS" {}
variable "RESOURCE_PREFIX" {}
variable "POOL_ID" {}
variable "CLIENT_ID" {}
variable "USER_TABLE" {}
variable "COGNITO_POOL_ARN" {}
variable "USER_TABLE_ARN" {}
locals {
  PYTHON_VERSION = "python3.12"
  LAMBDA_VERSION = "v1"
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "COMPUTE"}))
}
