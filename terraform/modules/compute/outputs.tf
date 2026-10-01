# Outputs the instance profile name for use by PostgreSQL EC2 instances.
output "instance_profile_name" {
  description = "Name of the IAM instance profile used by PostgreSQL nodes"
  value       = aws_iam_instance_profile.postgres.name
}
