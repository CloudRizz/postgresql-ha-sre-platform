# Outputs the stable NLB DNS endpoint used by PostgreSQL clients.
output "dns_name" {
  description = "DNS name of the PostgreSQL Network Load Balancer"
  value       = aws_lb.postgres.dns_name
}

# Outputs the PostgreSQL target group ARN for monitoring and integration.
output "target_group_arn" {
  description = "ARN of the PostgreSQL target group"
  value       = aws_lb_target_group.postgres.arn
}
