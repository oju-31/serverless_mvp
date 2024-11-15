terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "smarterise-webapp-aws-terraform-remote-state-centralized"
    dynamodb_table = "smarterise-webapp-aws-terraform-locks-centralized"
    region         = "us-east-1"
    key            = "smarterise-webapp-backend-infra/{{ENV}}/terraform.tfstate"
    encrypt        = true
  }
}
