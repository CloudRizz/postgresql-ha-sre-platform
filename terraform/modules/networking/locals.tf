# Maps each availability zone to its corresponding public and private subnet CIDR.
locals {
  public_subnets = {
    for index, az in var.availability_zones :
    az => var.public_subnet_cidrs[index]
  }

  private_subnets = {
    for index, az in var.availability_zones :
    az => var.private_subnet_cidrs[index]
  }
}

