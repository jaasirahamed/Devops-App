terraform {
  backend "s3" {
    bucket         = "devops-app-terraform-state-test"
    key            = "test/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-test"
    encrypt        = true
  }
}