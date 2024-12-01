
data "archive_file" "send_prompts" {
  type        = "zip"
  source_dir  = "${path.root}/backend/send_prompts_pkg"
  output_path = "${path.root}/backend/zip/send_prompts.zip"
}
data "archive_file" "get_token" {
  type        = "zip"
  source_dir  = "${path.root}/backend/get_token_pkg"
  output_path = "${path.root}/backend/zip/get_token.zip"
}
data "archive_file" "store_images" {
  type        = "zip"
  source_dir  = "${path.root}/backend/store_images_pkg"
  output_path = "${path.root}/backend/zip/store_images.zip"
}
data "archive_file" "get_images" {
  type        = "zip"
  source_dir  = "${path.root}/backend/get_images_pkg"
  output_path = "${path.root}/backend/zip/get_images.zip"
}
data "archive_file" "get_albums" {
  type        = "zip"
  source_dir  = "${path.root}/backend/get_albums_pkg"
  output_path = "${path.root}/backend/zip/get_albums.zip"
}
data "archive_file" "update_album" {
  type        = "zip"
  source_dir  = "${path.root}/backend/update_album_pkg"
  output_path = "${path.root}/backend/zip/update_album.zip"
}