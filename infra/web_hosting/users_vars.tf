variable "ENV" {}
variable "COMMON_TAGS" {}
variable "APP_NAME" {}
variable "RESOURCE_PREFIX" {}
locals {
  FRONTEND_FILES = fileset("${path.root}/frontend", "**")
}
