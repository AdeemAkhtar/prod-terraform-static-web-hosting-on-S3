variable "aws_region" {
  description = "AWS region for the production website infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "prod"
}

variable "bucket_name" {
  description = "Base name for the production website bucket."
  type        = string
  default     = "<YOUR_WEBSITE_S3_BUCKET>"
}

variable "cloudfront_price_class" {
  description = "CloudFront price class to control edge-location coverage and cost."
  type        = string
  default     = "PriceClass_100"
}

variable "domain_names" {
  description = "Custom domain names for the production website."
  type        = list(string)
  default     = ["<YOUR_DOMAIN>", "<www.YOUR_DOMAIN>"]
}

variable "acm_certificate_arn" {
  description = "Issued ACM certificate ARN in us-east-1."
  type        = string
  default     = null
}

variable "minimum_protocol_version" {
  description = "Minimum TLS protocol version for production."
  type        = string
  default     = "TLSv1.2_2021"
}