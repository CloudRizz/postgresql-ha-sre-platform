# Defines the project name used for the resource naming and tagging
variable "project_name" {
  description = "Name of project"
  type = string
  default = "postgresql-ha-sre"
}

# Defines the deployment envrironment such as dev, staging or prod
variable "environment" {
  description = "Deployment environment"
  type = string
  default = "prod"
}

# Defines the AWS region where infrastructure will be deployed
variable "aws_region" {
  description = "AWS region used for deployment"
  type = string
  default = "eu-west-2"
}

# Defines the private IPv4 address range allocated to the VPC
variable "vpc_cidr" {
  description = "CIR block for VPV"
  type = string
  default = "10.20.0.0/16"
}
