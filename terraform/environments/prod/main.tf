# Deploys the multi-AZ network used by the PostgreSQL HA platform.
module "networking" {
  source = "../../modules/networking"

  name_prefix          = local.name_prefix
  vpc_cidr             = var.vpc_cidr
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}

# Deploys network security controls for the PostgreSQL HA platform.
module "security" {
  source = "../../modules/security"

  name_prefix = local.name_prefix
  vpc_id      = module.networking.vpc_id
}

# Creates the IAM and Systems Manager access used by PostgreSQL compute nodes.
module "compute" {
  source = "../../modules/compute"

  name_prefix = local.name_prefix
}
