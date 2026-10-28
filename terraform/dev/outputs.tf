output "bucket_name" {
  description = "Name of the private website bucket."
  value       = module.static_site.bucket_name
}

output "bucket_arn" {
  description = "ARN of the private website bucket."
  value       = module.static_site.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "ID of the CloudFront distribution."
  value       = module.static_site.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "Default CloudFront domain name."
  value       = module.static_site.cloudfront_domain_name
}

output "website_url" {
  description = "HTTPS URL of the website."
  value       = module.static_site.website_url
}
