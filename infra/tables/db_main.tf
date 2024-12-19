locals {
  TAGS = merge(var.COMMON_TAGS, tomap({"ResourceType" = "DATABASE"}))
}

# resource "aws_dynamodb_table" "album_table" {
#   name           = "${var.RESOURCE_PREFIX}-album-table"
#   billing_mode   = "PAY_PER_REQUEST"
#   hash_key       = "UserID"
#   range_key      = "AlbumID"
#   tags           = local.TAGS

#   attribute {
#     name = "UserID"
#     type = "S"
#   }
#   attribute {
#     name = "AlbumID"
#     type = "S"
#   }

# }

resource "aws_dynamodb_table" "album_table" {
  name           = "${var.RESOURCE_PREFIX}-albums-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "sk"
  tags           = local.TAGS

  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }

}