variable "COMMON_TAGS" {}
variable "RESOURCE_PREFIX" {}
variable "ENV" {}
locals {
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "DATABASE"}))
}
