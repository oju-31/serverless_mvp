data "archive_file" "lambda_login_archive" {
  type        = "zip"
  source_dir  = "${path.root}/backend/open/log-in"
  output_path = "${path.root}/backend/open/zip/signup.zip"
}
