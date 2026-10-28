module "static_site" {
  source = "../modules/static-site"

  domain_names             = var.domain_names
  acm_certificate_arn      = aws_acm_certificate_validation.site.certificate_arn
  minimum_protocol_version = var.minimum_protocol_version

  bucket_name = var.bucket_name
  environment = var.environment
  price_class = var.cloudfront_price_class
}
