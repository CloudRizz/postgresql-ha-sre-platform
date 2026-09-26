# Defines the project name used for the resource naming and tagging
variable "project_name" {
  description = "Name of project"
  type        = string
  default     = "postgresql-ha-sre"
}

# Defines the deployment envrironment such as dev, staging or prod
variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "prod"
}

# Defines the AWS region where infrastructure will be deployed
variable "aws_region" {
  description = "AWS region used for deployment"
  type        = string
  default     = "eu-west-2"
}

# Defines the private IPv4 address range allocated to the VPC
variable "vpc_cidr" {
  description = "CIR block for VPV"
  type        = string
  default     = "10.20.0.0/16"
}

# Defines the availability zones used by the production environment.
variable "availability_zones" {
  description = "Availability zones used by the production environment"
  type        = list(string)
  default = [
    "eu-west-2a",
    "eu-west-2b"
  ]
}

# Defines the public subnet address ranges used by the production environment.
variable "public_subnet_cidrs" {
  description = "CIDR blocks allocated to public subnets"
  type        = list(string)
  default = [
    "10.20.1.0/24",
    "10.20.2.0/24"
  ]
}

# Defines the private database subnet address ranges used by the production environment.
variable "private_subnet_cidrs" {
  description = "CIDR blocks allocated to private database subnets"
  type        = list(string)
  default = [
    "10.20.11.0/24",
    "10.20.12.0/24"
  ]
}
