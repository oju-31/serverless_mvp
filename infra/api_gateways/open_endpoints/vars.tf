variable "ENV" {}
variable "COMMON_TAGS" {}
variable "CURRENT_ACCOUNT_ID" {}
variable "API_DOMAIN_NAME" {}
variable "RESOURCE_PREFIX" {
  default = "open"
}
variable "LAMBDA_NAMES" {
  description = "contains Names of lambda(s) to be added into <aws_lambda_permission> resource"
  type        = list(string)
}
