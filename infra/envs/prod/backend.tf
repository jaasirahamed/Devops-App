terraform {
  backend "s3" {
    bucket         = "devops-app-terraform-state-prod"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-prod"
    encrypt        = true
  }
}