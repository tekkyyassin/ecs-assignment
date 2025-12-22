
output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "VPC CIDR"
  value       = aws_vpc.main.cidr_block
}

output "igw_id" {
  description = "Internet Gateway ID"
  value       = aws_internet_gateway.igw.id
}

output "azs" {
  description = "Availability Zones in use"
  value       = var.azs
}

output "public_subnet_ids" {
  description = "Public subnet IDs (ordered to match azs)"
  value       = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  description = "Private subnet IDs (ordered to match azs)"
  value       = aws_subnet.private_subnets[*].id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value       = aws_route_table.public_rt.id
}

output "private_route_table_ids" {
  description = "Private route table IDs (one per AZ)"
  value       = aws_route_table.private_rts[*].id
}

output "nat_gateway_ids" {
  description = "NAT gateway IDs (one per AZ)"
  value       = aws_nat_gateway.nat_gateways[*].id
}

output "nat_eip_ids" {
  description = "Elastic IP allocation IDs backing NAT gateways (one per AZ)"
  value       = aws_eip.nat_eips[*].id
}
