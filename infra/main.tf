terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

# Local values for computed names and tags
locals {
  # Common tags to be applied to all resources
  common_tags = {
    Environment   = var.environment
    Project       = var.project_name
    Owner         = var.owner
    CreatedBy     = "terraform"
    ManagedBy     = "terraform"
    Application   = var.application_name
  }

  # Computed names
  vpc_name           = "${var.project_name}-${var.environment}-vpc"
  cluster_name       = "${var.project_name}-${var.environment}-${var.cluster_suffix}"
  app_name           = "${var.project_name}-${var.environment}-${var.application_name}"
  ssm_parameter_name = "/${var.project_name}/${var.environment}/${var.secret_name}"
}

# Network Infrastructure
module "network" {
  source = "./modules/network"
  
  environment     = var.environment
  project_name    = var.project_name
  vpc_cidr        = var.vpc_cidr
  azs             = var.azs
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
  
  tags = local.common_tags
}

# ECS Infrastructure
module "ecs" {
  source = "./modules/ecs"
  
  cluster_name = local.cluster_name
  vpc_id       = module.network.vpc_id
  subnets      = module.network.private_subnets
  environment  = var.environment
  project_name = var.project_name
  
  # ECS Task Configuration
  task_cpu       = var.task_cpu
  task_memory    = var.task_memory
  desired_count  = var.desired_count
  
  # Container Configuration
  container_name  = var.container_name
  container_image = var.container_image
  container_port  = var.container_port
  
  # AWS Configuration
  aws_region   = var.aws_region
  account_id   = var.account_id
  secret_name  = var.secret_name
  
  tags = local.common_tags
}

# SSM Parameter Store
module "ssm" {
  source = "./modules/ssm"
  
  parameter_name = local.ssm_parameter_name
  app_secret     = var.app_secret
  environment    = var.environment
  project_name   = var.project_name
  
  tags = local.common_tags
}