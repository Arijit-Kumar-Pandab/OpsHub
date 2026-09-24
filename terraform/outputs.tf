output "vpc_id" {
  description = "ID of the OpsHub VPC"
  value       = aws_vpc.opshub.id
}

output "vpc_cidr" {
  description = "CIDR block of the OpsHub VPC"
  value       = aws_vpc.opshub.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "availability_zones" {
  description = "Availability Zones used by OpsHub"
  value       = data.aws_availability_zones.available.names
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.opshub.id
}