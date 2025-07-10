resource "aws_dynamodb_table" "user_table" {
  name           = "${var.RESOURCE_PREFIX}-users-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "userID"
  tags           = local.TAGS
  
  deletion_protection_enabled = var.ENV == "prod" ? true : false
  
  attribute {
    name = "userID"
    type = "S"
  }
}

# add another table here if for your application
# add s3 bucket here if you need one for your application