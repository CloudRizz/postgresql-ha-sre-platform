# Creates the internal Network Load Balancer used as the stable PostgreSQL endpoint.
resource "aws_lb" "postgres" {
  name               = "${var.name_prefix}-nlb"
  internal           = true
  load_balancer_type = "network"
  subnets            = values(var.private_subnet_ids)
  security_groups    = [var.security_group_id]

  enable_deletion_protection = false
}

# Creates the PostgreSQL target group using Patroni for primary-aware health checks.
resource "aws_lb_target_group" "postgres" {
  name     = "${var.name_prefix}-pg"
  port     = 5432
  protocol = "TCP"
  vpc_id   = var.vpc_id

  health_check {
    enabled  = true
    protocol = "HTTP"
    port     = "8008"
    path     = "/primary"
  }
}

# Registers both PostgreSQL nodes so Patroni health checks determine the writable primary.
resource "aws_lb_target_group_attachment" "postgres" {
  for_each = var.instance_ids

  target_group_arn = aws_lb_target_group.postgres.arn
  target_id        = each.value
  port             = 5432
}

# Listens for PostgreSQL client connections and forwards them to the healthy primary.
resource "aws_lb_listener" "postgres" {
  load_balancer_arn = aws_lb.postgres.arn
  port              = 5432
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.postgres.arn
  }
}
