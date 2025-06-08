locals {
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "DATABASE"}))
}

resource "aws_dynamodb_table" "image_table" {
  name           = "${var.RESOURCE_PREFIX}-images-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "albumID"
  range_key      = "imageID"
  tags           = local.TAGS
  attribute {
    name = "albumID"
    type = "S"
  }
  attribute {
    name = "imageID"
    type = "S"
  }

}

resource "aws_dynamodb_table" "user_table" {
  name           = "${var.RESOURCE_PREFIX}-users-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userID"
  tags           = local.TAGS
  attribute {
    name = "userID"
    type = "S"
  }
}

