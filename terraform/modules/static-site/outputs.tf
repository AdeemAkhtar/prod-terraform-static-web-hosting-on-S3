output "bucket_name" {
  description = "Name of the private website bucket."
  value       = aws_s3_bucket.site.id
}

output "bucket_arn" {
  description = "ARN of the private website bucket."
  value       = aws_s3_bucket.site.arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = aws_cloudfront_distribution.site.id
}

output "cloudfront_domain_name" {
  description = "Default CloudFront domain name."
  value       = aws_cloudfront_distribution.site.domain_name
}

output "website_url" {
  description = "HTTPS URL of the website."
  value       = "https://${aws_cloudfront_distribution.site.domain_name}"
}
