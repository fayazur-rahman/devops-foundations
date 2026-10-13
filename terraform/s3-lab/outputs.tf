output "bucket_name" {
  description = "Name of the lab bucket"
  value       = module.lab_bucket.name
}

output "bucket_arn" {
  description = "ARN of the lab bucket"
  value       = module.lab_bucket.arn
}