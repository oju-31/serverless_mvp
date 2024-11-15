terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "smarterise-webapp-aws-terraform-remote-state-centralized"
    dynamodb_table = "smarterise-webapp-aws-terraform-locks-centralized"
    region         = "us-east-1"
    key            = "smarterise-webapp-backend-infra/{{ENV}}/terraform.tfstate"
  }
  required_version = ">=0.13.0"
  required_providers {
    aws = {
      version = ">= 2.7.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {}

data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
