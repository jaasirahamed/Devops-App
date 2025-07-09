terraform {
  backend "s3" {
    bucket         = "devops-app-terraform-state-qa"
    key            = "qa/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-qa"
    encrypt        = true
  }
}