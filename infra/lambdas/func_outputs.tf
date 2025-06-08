output "LAMBDA_SEWING_GUIDES_ENDPOINT" {
  value = aws_lambda_function_url.sewing_guides.function_url
}

output "LAMBDA_STORE_MNGT_ENDPOINT" {
  value = aws_lambda_function_url.store_mngt.function_url
}

output "LAMBDA_STYLE_GENERATIONS_ENDPOINT" {
  value = aws_lambda_function_url.style_generations.function_url
}

output "LAMBDA_USER_MNGT_ENDPOINT" {
  value = aws_lambda_function_url.user_mngt.function_url
}
