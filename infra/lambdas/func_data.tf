# This paryt of the code is used to create zip files for various backend services.
# because lambda functions in AWS require the code to be packaged in a zip file.

data "archive_file" "my_mvp" {
  type        = "zip"
  source_dir  = "${path.root}/backend/code/my_mvp"
  output_path = "${path.root}/backend/zip/my_mvp.zip"
}

data "archive_file" "user_mngt" {
  type        = "zip"
  source_dir  = "${path.root}/backend/code/user_mngt"
  output_path = "${path.root}/backend/zip/user_mngt.zip"
}