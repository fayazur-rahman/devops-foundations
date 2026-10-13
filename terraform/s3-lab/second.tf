module "scratch_bucket" {
  source = "../modules/s3-bucket"


  name = "${local.bucket_name}-scratch"
  tags = merge(local.common_tags, { Purpose = "scratch" })
}

