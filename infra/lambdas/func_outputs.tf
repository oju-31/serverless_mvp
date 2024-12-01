

output "LAMBDA_SEND_PROMPTS_ENDPOINT" {
  value = aws_lambda_function_url.send_prompts.function_url
}
output "LAMBDA_GET_TOKEN_ENDPOINT" {
  value = aws_lambda_function_url.get_token.function_url
}
output "LAMBDA_STORE_IMAGES_ENDPOINT" {
  value = aws_lambda_function_url.store_images.function_url
}
output "LAMBDA_GET_IMAGES_ENDPOINT" {
  value = aws_lambda_function_url.get_images.function_url
}
output "LAMBDA_GET_ALBUMS_ENDPOINT" {
  value = aws_lambda_function_url.get_albums.function_url
}
output "LAMBDA_UPDATE_ALBUM_ENDPOINT" {
  value = aws_lambda_function_url.update_album.function_url
}