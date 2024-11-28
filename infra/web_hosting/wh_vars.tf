variable "ENV" {} 
variable "RESOURCE_PREFIX" {}
variable "COMMON_TAGS" {}
variable "GITHUB_ACTIONS_USER_ARN" {} 
locals {
  S3_TAGS        = merge(var.COMMON_TAGS, tomap({"ResourceType" = "STORAGE"}))
  CDN_TAGS       = merge(var.COMMON_TAGS, tomap({"ResourceType" = "CDN"}))
  FRONTEND_FILES = fileset("${path.root}/frontend", "**")
}