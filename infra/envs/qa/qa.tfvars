aws_region = "us-east-1"
environment = "qa"
project_name = "devops-app"
application_name = "app"
owner = "devops-team"
cluster_suffix = "ecs-cluster"
secret_name = "app-secret"

# Network configuration
vpc_cidr = "10.1.0.0/16"
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets = ["10.1.1.0/24", "10.1.2.0/24", "10.1.3.0/24"]
private_subnets = ["10.1.101.0/24", "10.1.102.0/24", "10.1.103.0/24"]

# Application configuration
app_secret = "qa-secure-secret-value"

# Backend configuration
state_bucket_name = "devops-app-terraform-state-qa"
dynamodb_table_name = "terraform-lock-qa"
state_key_prefix = "qa/terraform.tfstate"