aws_region = "us-east-1"
environment = "staging"
project_name = "devops-app"
application_name = "app"
owner = "devops-team"
cluster_suffix = "ecs-cluster"
secret_name = "app-secret"

# Network configuration
vpc_cidr = "10.2.0.0/16"
azs = ["us-east-1a", "us-east-1b", "us-east-1c"]
public_subnets = ["10.2.1.0/24", "10.2.2.0/24", "10.2.3.0/24"]
private_subnets = ["10.2.101.0/24", "10.2.102.0/24", "10.2.103.0/24"]

# Application configuration
app_secret = "staging-secure-secret-value"

# Backend configuration
state_bucket_name = "devops-app-terraform-state-staging"
dynamodb_table_name = "terraform-lock-staging"
state_key_prefix = "staging/terraform.tfstate"