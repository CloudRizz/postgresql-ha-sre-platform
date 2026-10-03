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

# Creates the security group protecting the PostgreSQL Network Load Balancer.
resource "aws_security_group" "nlb" {
  name        = "${var.name_prefix}-nlb-sg"
  description = "Controls access to the PostgreSQL Network Load Balancer"
  vpc_id      = var.vpc_id

  tags = {
    Name = "${var.name_prefix}-nlb-sg"
  }
}

# Allows the Network Load Balancer to reach PostgreSQL and Patroni health endpoints.
resource "aws_vpc_security_group_egress_rule" "nlb_postgres" {
  security_group_id = aws_security_group.nlb.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 5432
  to_port           = 5432
  ip_protocol       = "tcp"
  description       = "Allow PostgreSQL traffic to database nodes"
}

# Allows Patroni health checks from the Network Load Balancer.
resource "aws_vpc_security_group_egress_rule" "nlb_patroni" {
  security_group_id = aws_security_group.nlb.id
  cidr_ipv4         = var.vpc_cidr
  from_port         = 8008
  to_port           = 8008
  ip_protocol       = "tcp"
  description       = "Allow Patroni health checks to database nodes"
}

# Allows PostgreSQL connections from the Network Load Balancer.
resource "aws_vpc_security_group_ingress_rule" "postgres_from_nlb" {
  security_group_id            = aws_security_group.postgres.id
  referenced_security_group_id = aws_security_group.nlb.id
  from_port                    = 5432
  to_port                      = 5432
  ip_protocol                  = "tcp"
  description                  = "Allow PostgreSQL traffic from the NLB"
}

# Allows Patroni health checks from the Network Load Balancer.
resource "aws_vpc_security_group_ingress_rule" "patroni_from_nlb" {
  security_group_id            = aws_security_group.postgres.id
  referenced_security_group_id = aws_security_group.nlb.id
  from_port                    = 8008
  to_port                      = 8008
  ip_protocol                  = "tcp"
  description                  = "Allow Patroni health checks from the NLB"
}
