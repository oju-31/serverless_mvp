resource "aws_s3_bucket" "webapp" { 
  bucket = "${lower(var.ENV)}.${var.RESOURCE_IDENTIFIER}-app-webapp-frontend" 
  tags = "${merge( 
    local.common_tags, 
    tomap({
      "Purpose" = "Store static website files for pgraters webapp access through Cloudfront", 
      "Name" = "${lower(var.ENV)}-${var.RESOURCE_IDENTIFIER}-webapp-cloudfront" 
    })
  )}" 
}

resource "aws_s3_bucket_logging" "webapp_log" {
  bucket        = aws_s3_bucket.webapp.id
  target_bucket = "${data.aws_caller_identity.current.account_id}-logs" 
  target_prefix = "s3-logs/${var.RESOURCE_IDENTIFIER}-${lower(var.ENV)}/"
}

# resource "aws_s3_bucket_acl" "webapp_acl" {
#   bucket = aws_s3_bucket.webapp.id
#   acl    = "private"
# }

resource "aws_s3_bucket_policy" "webapp" {
  bucket     = "${aws_s3_bucket.webapp.id}"

  policy = <<POLICY
{
  "Version": "2012-10-17", 
  "Id": "BUCKETPOLICY", 
  "Statement": [
    { 
      "Sid": "", 
      "Effect": "Allow", 
      "Principal": { 
          "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}" 
      }, 
      "Action": "s3:GetObject", 
      "Resource": "${aws_s3_bucket.webapp.arn}/*" 
    }, 
    { 
      "Sid": "", 
      "Effect": "Allow", 
      "Principal": { 
          "AWS": "${aws_cloudfront_origin_access_identity.origin_access_identity.iam_arn}" 
      }, 
      "Action": "s3:ListBucket", 
      "Resource": "${aws_s3_bucket.webapp.arn}" 
    }, 
    { 
      "Sid": "DenyInsecureAccess", 
      "Effect": "Deny", 
      "Principal": "*", 
      "Action": "*", 
      "Resource": [ 
        "${aws_s3_bucket.webapp.arn}", 
        "${aws_s3_bucket.webapp.arn}/*" 
      ], 
      "Condition": { 
        "Bool": { 
          "aws:SecureTransport": "false" 
        } 
      } 
    }
  ]
}
POLICY
}

