# Outputs the VPC identifier for use by other infrastructure modules.
output "vpc_id" {
  description = "ID of the PostgreSQL platform VPC"
  value       = aws_vpc.main.id
}

# Outputs public subnet IDs keyed by availability zone.
output "public_subnet_ids" {
  description = "Public subnet IDs keyed by availability zone"
  value = {
    for az, subnet in aws_subnet.public :
    az => subnet.id
  }
}

# Outputs private database subnet IDs keyed by availability zone.
output "private_subnet_ids" {
  description = "Private database subnet IDs keyed by availability zone"
  value = {
    for az, subnet in aws_subnet.private :
    az => subnet.id
  }
}
