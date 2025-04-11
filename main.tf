####################################################################################################################################################################
####################################################################################################################################################################
# LAMBDA FUNCTION, ITS ROLE AND THE ROLE'S POLICY
##########################################################################################################################
data "archive_file" "ahlorq_backend" {
  type        = "zip"
  source_dir  = "${path.root}/backend/code"
  output_path = "${path.root}/backend/zip/code.zip"
}

resource "aws_lambda_function" "ahlorq_styles" {
  filename         = "${path.root}/backend/zip/code.zip"
  function_name    = "one-backend-${local.RESOURCE_PREFIX}-${local.LAMBDA_VERSION}"
  role             = "${aws_iam_role.ahlorq_styles.arn}"
  handler          = "one_backend.lambda_handler"
  source_code_hash = data.archive_file.ahlorq_backend.output_base64sha256
  runtime          = local.PYTHON_VERSION
  timeout          = 300
  tags             = merge(local.COMMON_TAGS, tomap({"ResourceType" = "COMPUTE"}))
  environment {
    variables = {
      ENV       = var.ENV
      POOL_ID   = var.COGNITO_USER_POOL_ID
      CLIENT_ID = var.COGNITO_CLIENT_ID
      ALBUM_TABLE = aws_dynamodb_table.image_table.name
    }
  }
}

resource "aws_lambda_function_url" "ahlorq_styles" {
  function_name      = aws_lambda_function.ahlorq_styles.function_name
  authorization_type = "NONE"
}

resource "aws_iam_role" "ahlorq_styles" {
   name = "ahlorq-styles-lambda-role-${local.RESOURCE_PREFIX}"
   assume_role_policy = jsonencode({
     "Version" : "2012-10-17",
     "Statement" : [
       {
         "Action" : "sts:AssumeRole",
         "Principal" : {
           "Service" : "lambda.amazonaws.com"
         },
         "Effect" : "Allow",
         "Sid" : ""
       }
     ]
   })
 }

resource "aws_iam_role_policy" "ahlorq_styles" {
  name = "ahlorq-styles-lambda-policy-${local.RESOURCE_PREFIX}"
  role = aws_iam_role.ahlorq_styles.id
   policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow",
        Action = "*",
        Resource = [
          "*"
        ]
      }
    ]
  })
}


####################################################################################################################################################################
####################################################################################################################################################################
#  TABLES
##########################################################################################################################

resource "aws_dynamodb_table" "image_table" {
  name           = "${local.RESOURCE_PREFIX}-image-table"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "pk"
  range_key      = "sk"
  tags           = merge(local.COMMON_TAGS, tomap({"ResourceType" = "DATABASE"}))

  attribute {
    name = "pk"
    type = "S"
  }
  attribute {
    name = "sk"
    type = "S"
  }

}
# module "tables" {
#   source          = "./infra/tables"
#   COMMON_TAGS     = local.COMMON_TAGS
#   RESOURCE_PREFIX = local.RESOURCE_PREFIX
# }

####################################################################################################################################################################
####################################################################################################################################################################
# STATIC WEB HOSTING
############################################
# S3 bucket 

resource "aws_s3_bucket" "ahlorq_frontend" {
  bucket =  "${local.RESOURCE_PREFIX}s"
  tags   = merge(local.COMMON_TAGS, tomap({"ResourceType" = "STORAGE"}))
}

resource "aws_s3_bucket_website_configuration" "ahlorq_frontend" {
  bucket = aws_s3_bucket.ahlorq_frontend.id
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
  bucket       = aws_s3_bucket.ahlorq_frontend.id
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

  source_hash = filemd5("${path.root}/frontend/${each.value}")
}

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket = aws_s3_bucket.ahlorq_frontend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# this is necesarry if you are deploying to an aws account that is not yours
resource "aws_s3_bucket_policy" "allow_public_access_and_gha" {
  bucket = aws_s3_bucket.ahlorq_frontend.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.ahlorq_frontend.arn}/*"
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
          "${aws_s3_bucket.ahlorq_frontend.arn}",
          "${aws_s3_bucket.ahlorq_frontend.arn}/*"
        ]
      }
    ]
  })
}

# CloudFront Distribution
resource "aws_cloudfront_distribution" "website_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  tags                = merge(local.COMMON_TAGS, tomap({"ResourceType" = "CDN"}))

  origin {
    domain_name = aws_s3_bucket_website_configuration.ahlorq_frontend.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.ahlorq_frontend.id}"

    custom_origin_config {
      http_port              = 80
      https_port             = 443
      origin_protocol_policy = "http-only"
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD", "OPTIONS"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-${aws_s3_bucket.ahlorq_frontend.id}"

    forwarded_values {
      query_string = false
      headers      = []

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}


####################################################################################################################################################################
#  COGNITO
##########################################################################################################################
resource "aws_cognito_user_pool" "ahlorq_users" {
  name = "${local.RESOURCE_PREFIX}-userpool"
  auto_verified_attributes = ["email"]
  username_attributes = ["email"]

  password_policy {
    minimum_length = 8
    require_uppercase = true
    require_lowercase = true
    require_numbers   = true
    require_symbols   = false
  }
}

resource "aws_cognito_user_pool_client" "ahlorq_ui" {
  name         ="${local.RESOURCE_PREFIX}-web-client"
  user_pool_id = aws_cognito_user_pool.ahlorq_users.id

  generate_secret = false

  allowed_oauth_flows_user_pool_client = true

  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = ["openid", "email", "profile"]

  callback_urls = ["https://${aws_cloudfront_distribution.website_cdn.domain_name}"]
  logout_urls = ["https://${aws_cloudfront_distribution.website_cdn.domain_name}/about"]

  supported_identity_providers = ["COGNITO"]

  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
}
