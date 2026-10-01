# Creates the security group protecting the PostgreSQL database nodes.
resource "aws_security_group" "postgres" {
  name        = "${var.name_prefix}-postgres-sg"
  description = "Controls network access between PostgreSQL HA nodes"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-postgres-sg"
  }
}

# Allows PostgreSQL traffic only between instances using the PostgreSQL security group.
resource "aws_vpc_security_group_ingress_rule" "postgres_internal" {
  security_group_id            = aws_security_group.postgres.id
  referenced_security_group_id = aws_security_group.postgres.id

  from_port   = 5432
  to_port     = 5432
  ip_protocol = "tcp"

  description = "Allow PostgreSQL traffic between HA database nodes"
}

# Allows database nodes to initiate outbound IPv4 connections when routing permits.
resource "aws_vpc_security_group_egress_rule" "postgres_outbound" {
  security_group_id = aws_security_group.postgres.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"

  description = "Allow outbound traffic from PostgreSQL nodes"
}
