variable "ENV" {}
variable "COMMON_TAGS" {}
variable "WEBAPP_DNS" {}
variable "RESOURCE_PREFIX" {}
variable "GITHUB_ACTIONS_USER_ARN" {}
locals {
  FRONTEND_FILES = fileset("${path.root}/frontend", "**")
}