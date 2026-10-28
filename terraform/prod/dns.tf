resource "aws_route53_zone" "primary" {
  name    = "<YOUR_DOMAIN>" #example.com
  comment = "Public DNS zone for <YOUR_DOMAIN>"

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

output "route53_zone_id" {
  description = "Route 53 hosted zone ID for the production domain."
  value       = aws_route53_zone.primary.zone_id
}

output "route53_name_servers" {
  description = "Authoritative nameservers assigned to the production domain."
  value       = aws_route53_zone.primary.name_servers
}

resource "aws_acm_certificate" "site" {
  domain_name               = "<YOUR_DOMAIN>" # example.com
  subject_alternative_names = ["<YOUR_DOMAIN>"] # www.example.com
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Environment = "prod"
    ManagedBy   = "Terraform"
  }
}

resource "aws_route53_record" "cert_validation" {
  for_each = toset([
    "<YOUR_DOMAIN>",
    "<www.YOUR_DOMAIN>",
  ])

  zone_id = aws_route53_zone.primary.zone_id

  name = one([
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.resource_record_name if dvo.domain_name == each.value
  ])

  type = one([
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.resource_record_type if dvo.domain_name == each.value
  ])

  records = [one([
    for dvo in aws_acm_certificate.site.domain_validation_options :
    dvo.resource_record_value if dvo.domain_name == each.value
  ])]

  ttl = 60
}

resource "aws_acm_certificate_validation" "site" {
  certificate_arn = aws_acm_certificate.site.arn

  validation_record_fqdns = [
    for record in aws_route53_record.cert_validation : record.fqdn
  ]
}

output "acm_certificate_arn" {
  description = "ARN of the validated production ACM certificate."
  value       = aws_acm_certificate.site.arn
}

resource "aws_route53_record" "website_a" {
  for_each = toset(["<YOUR_DOMAIN>", "<www.YOUR_DOMAIN>"])

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value
  type    = "A"

  alias {
    name                   = module.static_site.cloudfront_domain_name
    zone_id                = "<YOUR_HOSTED_ZONE_ID>" # Z2FDLAFATAQYW2
    evaluate_target_health = false
  }
}

resource "aws_route53_record" "website_aaaa" {
  for_each = toset(["<YOUR_DOMAIN>", "<www.YOUR_DOMAIN>"])

  zone_id = aws_route53_zone.primary.zone_id
  name    = each.value
  type    = "AAAA"

  alias {
    name                   = module.static_site.cloudfront_domain_name
    zone_id                = "<YOUR_HOSTED_ZONE_ID>" # Z2FDLAFATAQYW2
    evaluate_target_health = false
  }
}