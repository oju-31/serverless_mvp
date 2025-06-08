output "USER_TABLE_NAME" {
  value = aws_dynamodb_table.user_table.name
}

output "IMAGE_TABLE_NAME" {
  value = aws_dynamodb_table.image_table.name
}