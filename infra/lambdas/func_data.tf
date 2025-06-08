data "archive_file" "sewing_guides" {
  type        = "zip"
  source_dir  = "${path.root}/backend/code/sewing_guides"
  output_path = "${path.root}/backend/zip/sewing_guides.zip"
}

data "archive_file" "store_mngt" {
  type        = "zip"
  source_dir  = "${path.root}/backend/code/store_mngt"
  output_path = "${path.root}/backend/zip/store_mngt.zip"
}

data "archive_file" "style_generations" {
  type        = "zip"
  source_dir  = "${path.root}/backend/code/style_generations"
  output_path = "${path.root}/backend/zip/style_generations.zip"
}

data "archive_file" "user_mngt" {
  type        = "zip"
  source_dir  = "${path.root}/backend/code/user_mngt"
  output_path = "${path.root}/backend/zip/user_mngt.zip"
}