output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.groove.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = local.public_subnet_ids
}

output "public_subnets" {
  description = "Public subnets attributes."
  value = [for key, subnet in local.public_subnets : merge(subnet, {
    id = aws_subnet.public[key].id
  })]
}


