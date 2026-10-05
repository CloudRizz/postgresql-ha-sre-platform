# Outputs the bucket name required by the Ansible AWS SSM connection plugin.
output "ansible_ssm_bucket_name" {
  description = "S3 bucket used for temporary Ansible SSM file transfers"
  value       = aws_s3_bucket.ansible_ssm.bucket
}
