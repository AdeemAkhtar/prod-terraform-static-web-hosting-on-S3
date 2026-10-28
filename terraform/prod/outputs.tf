output "bucket_name" {
  description = "Name of the private production website bucket."
  value       = module.static_site.bucket_name
}

output "bucket_arn" {
  description = "ARN of the private production website bucket."
  value       = module.static_site.bucket_arn
}

output "cloudfront_distribution_id" {
  description = "ID of the production CloudFront distribution."
  value       = module.static_site.cloudfront_distribution_id
}

output "cloudfront_domain_name" {
  description = "Default production CloudFront domain name."
  value       = module.static_site.cloudfront_domain_name
}

output "website_url" {
  description = "HTTPS URL of the production website."
  value       = module.static_site.website_url
}
