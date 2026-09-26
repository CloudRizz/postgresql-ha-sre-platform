# Defines the AWS region used to host the Terraform State infrastructure
variable "aws_region" {
  description = "AWS region for Terraform infrastructure"
  type        = string
  default     = "eu-west-2"
}

# Defines the project name used when naming the Terraform state bucket.
variable "project_name" {
  description = "Project name used for Terraform state resources"
  type        = string
  default     = "postgresql-ha-sre"
}
