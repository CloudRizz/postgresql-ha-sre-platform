# Outputs the instance profile name for use by cluster EC2 instances.
output "instance_profile_name" {
  description = "Name of the IAM instance profile used by cluster nodes"
  value       = aws_iam_instance_profile.node.name
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

# Outputs the EC2 instance ID of the dedicated etcd quorum node.
output "etcd_instance_id" {
  description = "EC2 instance ID of the dedicated etcd quorum node"
  value       = aws_instance.etcd.id
}

# Outputs the private IP address of the dedicated etcd quorum node.
output "etcd_private_ip" {
  description = "Private IP address of the dedicated etcd quorum node"
  value       = aws_instance.etcd.private_ip
}
