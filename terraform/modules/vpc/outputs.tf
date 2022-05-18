# vpc output
output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.this.id
}

output "vpc_arn" {
  description = "ARN of the VPC"
  value       = aws_vpc.this.arn
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.this.cidr_block
}

# private subnet output
output "private_subnets" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.private[*].id
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.private[*].arn
}

# private subnet output
output "db_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = aws_subnet.db[*].id
}

output "db_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = aws_subnet.db[*].arn
}

output "private_subnets_cidr_blocks" {
  description = "List of cidr_blocks of private subnets"
  value       = aws_subnet.private[*].cidr_block
}

# public subnet output
output "public_subnets" {
  description = "List of IDs of public subnets"
  value       = aws_subnet.public[*].id
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = aws_subnet.public[*].arn
}

output "public_subnets_cidr_blocks" {
  description = "List of cidr_blocks of public subnets"
  value       = aws_subnet.public[*].cidr_block
}

output "aws_security_group_id" {
  value = aws_security_group.this.id
}

output "aws_db_subnet_group_name" {
  value = length(aws_db_subnet_group.db) > 0 ? aws_db_subnet_group.db[0].name : "NULL"
}

output "aws_alb_name" {
  description = "id of application load balancer"
  value       = aws_lb.alb.dns_name
}