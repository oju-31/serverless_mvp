terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "-aws-terraform-remote-state"              # prefix with your app name
    dynamodb_table = "-aws-terraform-lock-centralized"          # prefix with your app name
    region         = "us-east-1"                                # change to your region
    key            = "-monorepo-webapp-infra/terraform.tfstate" # prefix with your app name
  }
  required_version = ">=1.0"
  required_providers {
    aws = {
      version = ">= 4.0"
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.AWS_REGION
}

data "aws_caller_identity" "current" {}
