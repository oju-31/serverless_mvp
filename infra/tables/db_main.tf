locals {
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "DATABASE"}))
}

resource "aws_dynamodb_table" "style_table" {
  name           = "${var.RESOURCE_PREFIX}-style-table"
  billing_mode   = "PAY_PER_REQUEST"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "UserId"
  tags           = local.TAGS

  attribute {
    name = "UserId"
    type = "S"
  }
}