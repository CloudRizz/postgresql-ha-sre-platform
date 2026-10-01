# Defines the PostgreSQL nodes and maps each node to an availability zone.
locals {
  postgres_nodes = {
    pg-01 = var.availability_zones[0]
    pg-02 = var.availability_zones[1]
  }
}
