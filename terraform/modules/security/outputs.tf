# Outputs the PostgreSQL security group ID for use by the compute module.
output "postgres_security_group_id" {
  description = "ID of the security group attached to PostgreSQL nodes"
  value       = aws_security_group.postgres.id
}

# Outputs the NLB security group ID for the load balancing module.
output "nlb_security_group_id" {
  description = "Security group ID attached to the Network Load Balancer"
  value       = aws_security_group.nlb.id
}

# Outputs the etcd security group ID for use by the dedicated quorum node.
output "etcd_security_group_id" {
  description = "Security group ID attached to the dedicated etcd quorum node"
  value       = aws_security_group.etcd.id
}
