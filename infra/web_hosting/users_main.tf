
# ---------------------------------------------
# COGNITO
#----------------------------------------------
resource "aws_cognito_user_pool" "ahlorq_users" {
  name                     = "${var.RESOURCE_PREFIX}-userpools"
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
# currently doing admin confirm to reduce steps in sign up
  verification_message_template {
    default_email_option = "CONFIRM_WITH_CODE"
    # email_message_by_link = "Please click the link below to verify your email address: {##Click Here##}. If you need any assistance please contact us at support@mealzine.com. We are here to assist. Regards, Mealzine Team"   
    email_subject = "[ahlorq] Confirm Your Email" 
    # email_subject_by_link = "Welcome to Mealzine"
    # sms_message = "Your  ${var.RESOURCE_PREFIX} reset password code is {####}"
  }
}

resource "aws_cognito_user_pool_client" "ahlorq_ui" {
  name         ="${var.RESOURCE_PREFIX}-web-client"
  user_pool_id = aws_cognito_user_pool.ahlorq_users.id
  generate_secret = false
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["code", "implicit"]
  allowed_oauth_scopes = ["openid", "email", "profile"]
  # callback_urls = ["https://${aws_cloudfront_distribution.website_cdn.domain_name}"]
  # logout_urls = ["https://${aws_cloudfront_distribution.website_cdn.domain_name}/about"]
  callback_urls = ["https://${var.WEBAPP_DNS}"]
  logout_urls   = ["https://${var.WEBAPP_DNS}"]
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
resource "aws_s3_bucket" "ahlorq_frontend" {
  bucket =  "${var.RESOURCE_PREFIX}-frontend"
  tags   = merge(var.COMMON_TAGS, tomap({"ResourceType" = "Static Website"}))
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
  for_each     = local.FRONTEND_FILES
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

# ---------------------------------------------
# CLOUD FRONT DISTRIBUTION 
#----------------------------------------------
resource "aws_cloudfront_distribution" "ahlorq_cdn" {
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  tags                = merge(var.COMMON_TAGS, tomap({"ResourceType" = "CDN"}))

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
    min_ttl     = 0
    default_ttl = var.ENV == "dev" ? 5 : var.ENV == "prod" ? 3600 : 3600
    max_ttl     = 86400
  }

  aliases = local.ALIASSES  

  viewer_certificate {
    acm_certificate_arn      = "arn:aws:acm:us-east-1:${var.ACCOUNT_ID}:certificate/${var.WEBAPP_CERT_ID}"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }
}


# ---------------------------------------------
# ROUTE 53 ALIAS RECORDS
#---------------------------------------------- 
resource "aws_route53_zone" "ahlorq_zone" {
  name = "${var.ROUTE53_HOSTED_ZONE_NAME}"
}

resource "aws_route53_record" "root" {
  zone_id = aws_route53_zone.ahlorq_zone.zone_id
  name    = var.WEBAPP_DNS
  type    = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.ahlorq_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.ahlorq_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "www" {
  zone_id = aws_route53_zone.ahlorq_zone.zone_id
  name    = "www.${var.WEBAPP_DNS}"
  type    = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.ahlorq_cdn.domain_name
    zone_id                = aws_cloudfront_distribution.ahlorq_cdn.hosted_zone_id
    evaluate_target_health = false
  }
}
