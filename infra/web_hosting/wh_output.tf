output "S3_FRONTEND_BUCKET_NAME" {
  value = aws_s3_bucket.website.id
  description = "This is used to sync frontend with the s3 website bucket."
}

output "CLOUDFRONT_DOMAIN_NAME" {
  value       = aws_cloudfront_distribution.website_cdn.domain_name
  description = "This is used to construct the login url in the root output file."
}
