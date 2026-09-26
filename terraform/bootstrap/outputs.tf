# Outputs the generated S3 bucket name required by the production backend.
output "state_bucket_name" {
  description = "Name of the Terraform remote state bucket"
  value       = aws_s3_bucket.terraform_state.id
}

# Outputs the AWS region containing the Terraform remote state bucket.
output "state_bucket_region" {
  description = "AWS region containing the Terraform state bucket"
  value       = var.aws_region
}