locals {
  PYTHON_VERSION = "python3.12"
  LAMBDA_VERSION = "v1"
  TAGS           = merge(var.COMMON_TAGS, tomap({"ResourceType" = "STORAGE"}))
  FRONTEND_FILES = fileset("${path.root}/frontend", "**")
}

resource "aws_s3_bucket" "website" {
  bucket = "${var.RESOURCE_PREFIX}"
  tags   = local.TAGS
}

resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "pages/error.html"
  }
}

# Optional: Initial file uploads via Terraform
resource "aws_s3_object" "frontend_files" {
  for_each = local.FRONTEND_FILES
  bucket       = aws_s3_bucket.website.id
  key          = each.value
  source       = "${path.root}/frontend/${each.value}"
  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "json" = "application/json",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",         
    "jpeg" = "image/jpeg",        
    "gif"  = "image/gif" 
  }, regex("\\.([^.]+)$", each.value)[0], "application/octet-stream")

  etag = filemd5("${path.root}/frontend/${each.value}")
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.website.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# resource "aws_s3_bucket_policy" "allow_public_access" {
#   bucket = aws_s3_bucket.website.id
#   policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Sid       = "PublicReadGetObject"
#         Effect    = "Allow"
#         Principal = "*"
#         Action    = "s3:GetObject"
#         Resource  = "${aws_s3_bucket.website.arn}/*"
#       }
#     ]
#   })
# }

resource "aws_s3_bucket_policy" "allow_public_access_and_gha" {
  bucket = aws_s3_bucket.website.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.website.arn}/*"
      },
      {
        Sid      = "AllowGitHubActionsSync"
        Effect   = "Allow"
        Principal = {AWS = "${var.GITHUB_ACTIONS_USER_ARN}"}
        Action   = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:DeleteObject"
        ]
        Resource = [
          "${aws_s3_bucket.website.arn}",
          "${aws_s3_bucket.website.arn}/*"
        ]
      }
    ]
  })
}
