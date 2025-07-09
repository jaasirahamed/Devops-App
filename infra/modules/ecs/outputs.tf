output "cluster_id" {
  description = "ID of the ECS cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "Name of the ECS cluster"
  value       = aws_ecs_cluster.main.name
}

output "cluster_arn" {
  description = "ARN of the ECS cluster"
  value       = aws_ecs_cluster.main.arn
}

# Security Group Outputs
output "security_group_id" {
  description = "ID of the ECS security group"
  value       = aws_security_group.ecs_tasks.id
}

output "security_group_arn" {
  description = "ARN of the ECS security group"
  value       = aws_security_group.ecs_tasks.arn
}

# IAM Role Outputs
output "task_execution_role_arn" {
  description = "ARN of the ECS task execution role"
  value       = aws_iam_role.ecs_task_execution_role.arn
}

output "task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}

# ECS Service Outputs
output "service_id" {
  description = "ID of the ECS service"
  value       = aws_ecs_service.app.id
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.app.name
}

output "service_arn" {
  description = "ARN of the ECS service"
  value       = aws_ecs_service.app.id
}

# Task Definition Outputs
output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.app.arn
}

output "task_definition_family" {
  description = "Family of the ECS task definition"
  value       = aws_ecs_task_definition.app.family
}

output "task_definition_revision" {
  description = "Revision of the ECS task definition"
  value       = aws_ecs_task_definition.app.revision
}

# CloudWatch Log Group Output
output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_log_group.name
}

output "log_group_arn" {
  description = "ARN of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.ecs_log_group.arn
}