output "USER_TABLE_NAME" {
  value = aws_dynamodb_table.user_table.id
}

output "USER_TABLE_ARN" {
  value = aws_dynamodb_table.user_table.arn
}
#if you add another table, output the name here, your code in lambda function will probably need it