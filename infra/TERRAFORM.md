# Terraform Infrastructure Documentation

This document explains how to use the fully variablized Terraform configuration for deploying infrastructure across different environments.

## 🏗️ Architecture Overview

The infrastructure is designed with complete variablization to avoid hardcoded values:

- **Main Configuration**: `main.tf` - Contains all shared logic with variables
- **Environment-Specific**: Each environment has its own `.tfvars` and `backend.tf`
- **Modular Design**: Separate modules for network, ECS, and SSM
- **Common Tags**: Standardized tagging across all resources

## 📁 Directory Structure

```
infra/
├── main.tf                 # Main infrastructure configuration
├── provider.tf             # AWS provider configuration
├── deploy.sh              # Deployment automation script
├── envs/                  # Environment-specific configurations
│   ├── prod/
│   │   ├── backend.tf     # Production backend configuration
│   │   └── prod.tfvars    # Production variables
│   ├── qa/
│   │   ├── backend.tf     # QA backend configuration
│   │   └── qa.tfvars      # QA variables
│   ├── staging/
│   │   ├── backend.tf     # Staging backend configuration
│   │   └── staging.tfvars # Staging variables
│   └── test/
│       ├── backend.tf     # Test backend configuration
│       └── test.tfvars    # Test variables
└── modules/               # Reusable modules
    ├── network/           # VPC, subnets, routing
    ├── ecs/              # ECS cluster and security groups
    └── ssm/              # Parameter Store for secrets
```

## 🔧 Key Variables

### Project Configuration
- `project_name`: Name of the project (default: "devops-app")
- `application_name`: Name of the application (default: "app")
- `owner`: Owner of the resources (default: "devops-team")
- `environment`: Environment name (dev, test, qa, staging, prod)

### Network Configuration
- `vpc_cidr`: CIDR block for the VPC
- `azs`: List of availability zones
- `public_subnets`: Public subnet CIDR blocks
- `private_subnets`: Private subnet CIDR blocks

### Application Configuration
- `app_secret`: Secret value for the application (sensitive)
- `cluster_suffix`: Suffix for ECS cluster name
- `secret_name`: Name of the secret in SSM Parameter Store

### Backend Configuration
- `state_bucket_name`: S3 bucket for Terraform state
- `dynamodb_table_name`: DynamoDB table for state locking
- `state_key_prefix`: Prefix for the state key in S3

## 🚀 Deployment Methods

### Method 1: Using the Deployment Script (Recommended)

```bash
# Make the script executable
chmod +x deploy.sh

# Initialize Terraform for an environment
./deploy.sh prod init

# Plan deployment
./deploy.sh prod plan

# Apply changes
./deploy.sh prod apply

# Destroy resources (be careful!)
./deploy.sh prod destroy
```

### Method 2: Manual Terraform Commands

```bash
# Initialize with environment-specific backend
terraform init -backend-config=envs/prod/backend.tf

# Plan with environment-specific variables
terraform plan -var-file=envs/prod/prod.tfvars

# Apply with environment-specific variables
terraform apply -var-file=envs/prod/prod.tfvars

# Destroy with environment-specific variables
terraform destroy -var-file=envs/prod/prod.tfvars
```

## 🏷️ Resource Naming Convention

All resources are named using the following pattern:
- `${project_name}-${environment}-${resource_type}`
- Example: `devops-app-prod-vpc`, `devops-app-staging-ecs-cluster`

## 🔖 Common Tags

All resources are automatically tagged with:
- `Environment`: Current environment
- `Project`: Project name
- `Owner`: Resource owner
- `CreatedBy`: "terraform"
- `ManagedBy`: "terraform"
- `Application`: Application name

## 📊 Outputs

The configuration provides the following outputs:
- `vpc_id`: ID of the created VPC
- `public_subnet_ids`: List of public subnet IDs
- `private_subnet_ids`: List of private subnet IDs
- `ecs_cluster_id`: ID of the ECS cluster
- `ssm_parameter_arn`: ARN of the SSM parameter
- `resource_tags`: Common resource tags

## 🔐 Security Best Practices

1. **State Management**: Each environment has its own S3 bucket for state files
2. **Secrets**: App secrets are stored in SSM Parameter Store as SecureString
3. **Access Control**: Use IAM roles and policies to control access
4. **Encryption**: All S3 state buckets and DynamoDB tables use encryption

## 🌍 Environment-Specific Configuration

### Production (prod)
- VPC CIDR: 10.0.0.0/16
- State Bucket: devops-app-terraform-state-prod
- DynamoDB Table: terraform-lock-prod

### QA (qa)
- VPC CIDR: 10.1.0.0/16
- State Bucket: devops-app-terraform-state-qa
- DynamoDB Table: terraform-lock-qa

### Staging (staging)
- VPC CIDR: 10.2.0.0/16
- State Bucket: devops-app-terraform-state-staging
- DynamoDB Table: terraform-lock-staging

### Test (test)
- VPC CIDR: 10.3.0.0/16
- State Bucket: devops-app-terraform-state-test
- DynamoDB Table: terraform-lock-test

## 🔧 Customization

To customize for your project:

1. **Update Project Variables**: Modify the default values in `main.tf`
2. **Environment Variables**: Update `.tfvars` files for each environment
3. **Backend Configuration**: Update `backend.tf` files with your S3 bucket names
4. **Resource Configuration**: Modify module configurations as needed

## 📋 Prerequisites

Before deploying:

1. **AWS CLI**: Configure AWS credentials
2. **Terraform**: Install Terraform >= 1.0
3. **S3 Buckets**: Create state buckets for each environment
4. **DynamoDB Tables**: Create locking tables for each environment

## 🚨 Important Notes

- Always run `terraform plan` before `terraform apply`
- Use separate AWS accounts for different environments when possible
- Regularly backup your Terraform state files
- Review and approve all changes in production environments
- Use the deployment script for consistency across environments

## 🔄 CI/CD Integration

The GitHub Actions workflow automatically:
- Validates Terraform configuration
- Plans deployments for staging and production
- Applies changes with proper approvals
- Uses environment-specific configurations

## 📞 Support

For issues or questions:
1. Check the Terraform validate output
2. Review the deployment script logs
3. Verify your AWS credentials and permissions
4. Ensure all required S3 buckets and DynamoDB tables exist