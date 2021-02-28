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
