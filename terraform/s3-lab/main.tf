locals {
  bucket_name = "fayazur-${var.project}-${var.environment}-${var.name_suffix}"

  common_tags = merge(
    {
      Project     = var.project
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.extra_tags,
  )
}

module "lab_bucket" {
  source = "../modules/s3-bucket"


  name = local.bucket_name
  tags = local.common_tags
}
