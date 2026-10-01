# Defines the name prefix used when naming security resources.
variable "name_prefix" {
  description = "Name prefix used for security resources"
  type        = string
}

# Defines the VPC where the security groups are created.
variable "vpc_id" {
  description = "ID of the VPC containing the PostgreSQL platform"
  type        = string
}
