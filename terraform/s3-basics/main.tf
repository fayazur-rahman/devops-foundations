terraform {
  required_version = ">= 1.10"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 6.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "lab" {
  bucket = "fayazur-v2"

  tags = {
    Project   = "DevOps-foundation"
    ManagedBy = "Terraform"
    Lesson    = "w8d3"
  }
}