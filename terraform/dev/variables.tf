variable "aws_region" {
  description = "AWS region for the website infrastructure."
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Deployment environment."
  type        = string
  default     = "dev"
}

variable "bucket_name" {
  description = "Base name for the website bucket."
  type        = string
  default     = "<YOUR_WEBSITE_S3_BUCKET>"
}

variable "s3_state_bucket" {
  description = "Existing S3 bucket used for Terraform state."
  type        = string
  default     = "<YOUR_REMOTE_STATE_S3_BUCKET>"
}

variable "s3_key" {
  description = "Existing remote Terraform state key."
  type        = string
  default     = "<YOUR_REMOTE_STATE_S3_BUCKET>/dev/terraform.tfstate"
}

variable "cloudfront_price_class" {
  description = "CloudFront price class to control edge-location coverage and cost."
  type        = string
  default     = "PriceClass_100"
}
