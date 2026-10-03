# Defines the name prefix used when naming load balancing resources.
variable "name_prefix" {
  description = "Name prefix used for load balancing resources"
  type        = string
}

# Defines the VPC containing the PostgreSQL target group.
variable "vpc_id" {
  description = "ID of the VPC containing PostgreSQL nodes"
  type        = string
}

# Defines the private subnets used by the internal Network Load Balancer.
variable "private_subnet_ids" {
  description = "Map of availability zones to private subnet IDs"
  type        = map(string)
}

# Defines the PostgreSQL EC2 instance IDs registered with the target group.
variable "instance_ids" {
  description = "Map of PostgreSQL node names to EC2 instance IDs"
  type        = map(string)
}

# Defines the security group attached to the Network Load Balancer.
variable "security_group_id" {
  description = "Security group ID attached to the Network Load Balancer"
  type        = string
}