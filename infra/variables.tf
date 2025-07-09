# AWS Configuration
variable "aws_region" {
  description = "The AWS region to deploy resources in"
  type        = string
  default     = "us-east-1"
}

# Environment Configuration
variable "environment" {
  description = "Environment name (e.g., dev, test, qa, staging, prod)"
  type        = string
  validation {
    condition     = contains(["dev", "test", "qa", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, test, qa, staging, prod."
  }
}

# Project Configuration
variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "devops-app"
}

variable "application_name" {
  description = "Name of the application"
  type        = string
  default     = "app"
}

variable "owner" {
  description = "Owner of the resources"
  type        = string
  default     = "devops-team"
}

variable "cluster_suffix" {
  description = "Suffix for ECS cluster name"
  type        = string
  default     = "ecs-cluster"
}

variable "secret_name" {
  description = "Name of the secret in SSM Parameter Store"
  type        = string
  default     = "app-secret"
}

# Network Configuration
variable "vpc_cidr" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "azs" {
  description = "The availability zones for the VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "public_subnets" {
  description = "The public subnets for the VPC"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnets" {
  description = "The private subnets for the VPC"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}

# Application Configuration
variable "app_secret" {
  description = "The secret value for the application"
  type        = string
  sensitive   = true
}

# ECS Task Configuration
variable "task_cpu" {
  description = "CPU units for the ECS task"
  type        = string
  default     = "256"
}

variable "task_memory" {
  description = "Memory for the ECS task"
  type        = string
  default     = "512"
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
  default     = 1
}

# Container Configuration
variable "container_name" {
  description = "Name of the container"
  type        = string
  default     = "app"
}

variable "container_image" {
  description = "Docker image for the container"
  type        = string
  default     = "nginx:latest"
}

variable "container_port" {
  description = "Port on which the container listens"
  type        = number
  default     = 5000
}

# AWS Account Configuration
variable "account_id" {
  description = "AWS account ID"
  type        = string
  default     = ""
}

# Backend Configuration Variables (for reference)
variable "state_bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
  default     = "devops-app-terraform-state"
}

variable "dynamodb_table_name" {
  description = "Name of the DynamoDB table for state locking"
  type        = string
  default     = "terraform-lock"
}

variable "state_key_prefix" {
  description = "Prefix for the state key in S3"
  type        = string
  default     = "terraform.tfstate"
}