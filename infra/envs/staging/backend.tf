terraform {
  backend "s3" {
    bucket         = "devops-app-terraform-state-staging"
    key            = "staging/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-staging"
    encrypt        = true
  }
}