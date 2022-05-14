output "secret_arn" {
  value       = data.aws_secretsmanager_secret.dbkeys.arn
  description = "arn of secrets needed to connect to database"
  sensitive   = true
}

output "vpc" {
  value       = module.vpc.vpc_id
  description = "id of vpc"
  sensitive   = false
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.vpc.vpc_cidr_block
}

output "aws_security_group_id" {
  value = module.vpc.aws_security_group_id
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "private subnets"
}

output "private_subnet_arns" {
  description = "List of ARNs of private subnets"
  value       = module.vpc.private_subnet_arns
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "private subnets"
}

output "public_subnet_arns" {
  description = "List of ARNs of public subnets"
  value       = module.vpc.public_subnet_arns
}

output "rds_instance_name" {
  value = module.rds[0].instance_name
}

output "rds_port" {
  value = module.rds[0].port
}

output "rds_address" {
  value = module.rds[0].address
}

output "aws_alb_name" {
  value = module.vpc.aws_alb_name
}