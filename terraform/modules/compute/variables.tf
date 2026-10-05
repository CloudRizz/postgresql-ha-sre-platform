# Defines the name prefix used when naming compute resources.
variable "name_prefix" {
  description = "Name prefix used for compute resources"
  type        = string
}

# Defines the EC2 instance type used by PostgreSQL nodes.
variable "instance_type" {
  description = "EC2 instance type used by PostgreSQL nodes"
  type        = string
}

# Defines the private subnet assigned to each PostgreSQL node.
variable "private_subnet_ids" {
  description = "Map of availability zones to private subnet IDs"
  type        = map(string)
}

# Defines the security group attached to PostgreSQL nodes.
variable "security_group_id" {
  description = "Security group ID attached to PostgreSQL nodes"
  type        = string
}

# Defines the availability zones used by the PostgreSQL nodes.
variable "availability_zones" {
  description = "Availability zones used by PostgreSQL nodes"
  type        = list(string)
}

# Defines the EC2 instance type used by the dedicated etcd quorum node.
variable "etcd_instance_type" {
  description = "EC2 instance type used by the dedicated etcd quorum node"
  type        = string
}

# Defines the security group attached to the dedicated etcd quorum node.
variable "etcd_security_group_id" {
  description = "Security group ID attached to the dedicated etcd quorum node"
  type        = string
}
