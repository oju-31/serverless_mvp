data "archive_file" "lambda_login_archive" {
  type        = "zip"
  source_dir  = "${path.root}/backend/open/login_pkg"
  output_path = "${path.root}/backend/open/zip/login.zip"
}
