output "vpc_id" {
  description = "VPC ID."
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs."
  value       = aws_subnet.public.*.id
}

output "intra_subnet_ids" {
  description = "Intra subnet IDs."
  value       = aws_subnet.intra.*.id
}
