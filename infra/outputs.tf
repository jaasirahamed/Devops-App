# VPC Outputs
output "vpc_id" {
  description = "ID of the VPC"
  value       = module.network.vpc_id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = module.network.vpc_cidr_block
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = module.network.internet_gateway_id
}

# Subnet Outputs
output "public_subnet_ids" {
  description = "List of IDs of public subnets"
  value       = module.network.public_subnets
}

output "private_subnet_ids" {
  description = "List of IDs of private subnets"
  value       = module.network.private_subnets
}

output "nat_gateway_ids" {
  description = "List of IDs of NAT Gateways"
  value       = module.network.nat_gateway_ids
}

# ECS Outputs
output "ecs_cluster_id" {
  description = "ID of the ECS cluster"
  value       = module.ecs.cluster_id
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "ecs_cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = module.ecs.cluster_arn
}

output "ecs_security_group_id" {
  description = "ID of the ECS security group"
  value       = module.ecs.security_group_id
}

output "ecs_task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = module.ecs.task_execution_role_arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = module.ecs.task_role_arn
}

# SSM Outputs
output "ssm_parameter_arn" {
  description = "ARN of the SSM parameter"
  value       = module.ssm.parameter_arn
}

output "ssm_parameter_name" {
  description = "Name of the SSM parameter"
  value       = module.ssm.parameter_name
}

output "ssm_parameter_version" {
  description = "Version of the SSM parameter"
  value       = module.ssm.parameter_version
}

# Environment Information
output "environment" {
  description = "Current environment"
  value       = var.environment
}

output "project_name" {
  description = "Project name"
  value       = var.project_name
}

output "aws_region" {
  description = "AWS region"
  value       = var.aws_region
}

# Resource Tags
output "resource_tags" {
  description = "Common resource tags"
  value       = local.common_tags
}

# Computed Names
output "computed_names" {
  description = "Computed resource names"
  value = {
    vpc_name           = local.vpc_name
    cluster_name       = local.cluster_name
    app_name           = local.app_name
    ssm_parameter_name = local.ssm_parameter_name
  }
}