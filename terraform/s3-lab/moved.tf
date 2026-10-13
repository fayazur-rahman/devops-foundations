moved {
  from = aws_s3_bucket.lab
  to   = module.lab_bucket.aws_s3_bucket.this
}
