module "static_site" {
  source = "../modules/static-site"

  bucket_name = var.bucket_name
  environment = var.environment
  price_class = var.cloudfront_price_class
}
