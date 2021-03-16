output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = local.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs."
  value       = local.private_subnet_ids
}

output "intra_subnet_ids" {
  description = "Intra subnet IDs."
  value       = local.intra_subnet_ids
}

output "public_subnets" {
  description = "Public subnets attributes."
  value = [for key, subnet in local.public_subnets : merge(subnet, {
    id = aws_subnet.public[key].id
  })]
}

output "private_subnets" {
  description = "Private subnets attributes."
  value = [for key, subnet in local.private_subnets : merge(subnet, {
    id = aws_subnet.private[key].id
  })]
}

output "intra_subnets" {
  description = "Intra subnets attributes."
  value = [for key, subnet in local.intra_subnets : merge(subnet, {
    id = aws_subnet.intra[key].id
  })]
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
}
