variable "bucket_name" {
  description = "Globally unique base name for the website S3 bucket."
  type        = string
}

variable "environment" {
  description = "Deployment environment."
  type        = string
}

variable "price_class" {
  description = "CloudFront price class."
  type        = string
  default     = "PriceClass_100"
}

variable "domain_names" {
  description = "Optional Custom domain names for the cloudfront distribution."
  type        = list(string)
  default     = []
}

variable "acm_certificate_arn" {
  description = "ACM certificate ARN in us-east-1 for custom HTTPS domains."
  type        = string
  default     = null
}

variable "minimum_protocol_version" {
  description = "Minimum protocol version for HTTPS versions.."
  type        = string
  default     = "TLSv1"
}