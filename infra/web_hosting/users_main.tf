# ---------------------------------------------
# COGNITO
#----------------------------------------------
resource "aws_cognito_user_pool" "users_mngt" {
  name                     = "${var.RESOURCE_PREFIX}-user-pool"
  auto_verified_attributes = ["email"]
  username_attributes      = ["email"]
  tags                     = merge(var.COMMON_TAGS, tomap({"ResourceType" = "User Management"}))

  password_policy {
    minimum_length    = 8
    # require_uppercase = true
    # require_lowercase = true
    # require_numbers   = true
    # require_symbols   = false
  }
  
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject = "[${var.APP_NAME}] Confirm Your Email" 
  }
}

resource "aws_cognito_user_pool_client" "client_ui" {
  name         ="${var.RESOURCE_PREFIX}-web-client"
  user_pool_id = aws_cognito_user_pool.users_mngt.id
  generate_secret = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = ["openid", "email", "profile"]
  callback_urls = ["https://${aws_cloudfront_distribution.cdn.domain_name}"]
  logout_urls = ["https://${aws_cloudfront_distribution.cdn.domain_name}/about"]
  supported_identity_providers = ["COGNITO"]
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_CUSTOM_AUTH",
    "ALLOW_ADMIN_USER_PASSWORD_AUTH"
  ]
}

# ---------------------------------------------
# S3 BUCKET FOR FRONTEND
#----------------------------------------------
resource "aws_s3_bucket" "frontend" {
  bucket =  "${var.RESOURCE_PREFIX}-frontend"
  tags   = merge(var.COMMON_TAGS, tomap({"ResourceType" = "Static Website"}))
}

resource "aws_s3_bucket_website_configuration" "frontend" {
  bucket = aws_s3_bucket.frontend.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "pages/error.html"
  }
}

# This uploads the frontend files to the S3 bucket only 
# if they are not already present or if they have changed.
resource "aws_s3_object" "frontend" {
  for_each     = local.FRONTEND_FILES
  bucket       = aws_s3_bucket.frontend.id
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
  bucket = aws_s3_bucket.frontend.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}


# ---------------------------------------------
# CLOUD FRONT DISTRIBUTION 
#----------------------------------------------
resource "aws_cloudfront_distribution" "cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  tags                = merge(var.COMMON_TAGS, tomap({"ResourceType" = "CDN"}))

  origin {
    domain_name = aws_s3_bucket_website_configuration.frontend.website_endpoint
    origin_id   = "S3-${aws_s3_bucket.frontend.id}"

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
    target_origin_id = "S3-${aws_s3_bucket.frontend.id}"

    forwarded_values {
      query_string = false
      headers      = []
      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl     = 0
    default_ttl = var.ENV == "dev" ? 5 : var.ENV == "prod" ? 3600 : 3600
    max_ttl     = 86400
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
