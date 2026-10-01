# Outputs the PostgreSQL security group ID for use by the compute module.
output "postgres_security_group_id" {
  description = "ID of the security group attached to PostgreSQL nodes"
  value       = aws_security_group.postgres.id
}
