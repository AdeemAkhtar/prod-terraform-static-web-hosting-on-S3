# Provider configuration for AWS
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket       = "<YOUR_REMOTE_STATE_S3_BUCKET>"
    key          = "<YOUR_REMOTE_STATE_S3_BUCKET>/dev/terraform.tfstate"
    region       = "us-east-1"
    encrypt      = true
    use_lockfile = true
  }
}

# Configuring AWS Provider
provider "aws" {
  region = var.aws_region
}

