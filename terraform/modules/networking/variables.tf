# Defines the name prefix used when naming networking resources.
variable "name_prefix" {
  description = "Name prefix used for networking resources"
  type        = string
}

# Defines the IPv4 address range allocated to the VPC.
variable "vpc_cidr" {
  description = "CIDR block allocated to the VPC"
  type        = string
}

# Defines the availability zones used to distribute infrastructure.
variable "availability_zones" {
  description = "Availability zones used by the network"
  type        = list(string)
}

# Defines the public subnet CIDR blocks mapped to each availability zone.
variable "public_subnet_cidrs" {
  description = "CIDR blocks allocated to public subnets"
  type        = list(string)
}

# Defines the private database subnet CIDR blocks mapped to each availability zone.
variable "private_subnet_cidrs" {
  description = "CIDR blocks allocated to private database subnets"
  type        = list(string)
}
