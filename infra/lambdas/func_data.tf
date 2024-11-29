data "archive_file" "login" {
  type        = "zip"
  source_dir  = "${path.root}/backend/open/login_pkg"
  output_path = "${path.root}/backend/open/zip/login.zip"
}

data "archive_file" "generate_prompts" {
  type        = "zip"
  source_dir  = "${path.root}/backend/generators/generate_prompts_pkg"
  output_path = "${path.root}/backend/generators/zip/generate_prompts.zip"
}
