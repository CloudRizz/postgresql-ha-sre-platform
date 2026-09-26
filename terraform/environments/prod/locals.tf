# Creates a consitent naming prefix shared across project resources
locals {
  name_prefix = "${var.project_name}-${var.environment}"

  # Defines common metadata automatically applied to AWS resources
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "postgresql-ha-sre-platform"
  }
}
