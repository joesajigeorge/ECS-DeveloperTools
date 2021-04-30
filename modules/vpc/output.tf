output vpc_id {
  value       = aws_vpc.main.id
  description = "VPC Id"
}

output "public_subnet_ids" {
  value = [
    for s in aws_subnet.public_subnet : s.id
  ]
}

output "private_subnet_ids" {
  value = [
    for s in aws_subnet.private_subnet : s.id
  ]
}