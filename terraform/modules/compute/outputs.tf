# Outputs the instance profile name for use by PostgreSQL EC2 instances.
output "instance_profile_name" {
  description = "Name of the IAM instance profile used by PostgreSQL nodes"
  value       = aws_iam_instance_profile.postgres.name
}

# Outputs the EC2 instance IDs keyed by PostgreSQL node name.
output "instance_ids" {
  description = "EC2 instance IDs for PostgreSQL nodes"
  value = {
    for name, instance in aws_instance.postgres :
    name => instance.id
  }
}

# Outputs the private IP addresses keyed by PostgreSQL node name.
output "private_ips" {
  description = "Private IP addresses for PostgreSQL nodes"
  value = {
    for name, instance in aws_instance.postgres :
    name => instance.private_ip
  }
}
