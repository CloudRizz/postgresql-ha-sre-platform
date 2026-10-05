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
  vpc_cidr    = var.vpc_cidr
}

# Deploys the private EC2 nodes used by the PostgreSQL HA cluster.
module "compute" {
  source = "../../modules/compute"

  name_prefix            = local.name_prefix
  instance_type          = "t8i.small"
  etcd_instance_type     = "t8i.small"
  availability_zones     = var.availability_zones
  private_subnet_ids     = module.networking.private_subnet_ids
  security_group_id      = module.security.postgres_security_group_id
  etcd_security_group_id = module.security.etcd_security_group_id
}

# Deploys the internal Network Load Balancer providing the stable PostgreSQL endpoint.
module "load_balancing" {
  source = "../../modules/load_balancing"

  name_prefix        = local.name_prefix
  vpc_id             = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  instance_ids       = module.compute.instance_ids
  security_group_id  = module.security.nlb_security_group_id
}
