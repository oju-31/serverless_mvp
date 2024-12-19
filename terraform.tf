terraform {
  backend "s3" {
    encrypt        = true
    bucket         = "ahlorq-styles-webapp-aws-terraform-remote-state-centralized"
    dynamodb_table = "ahlorq-styles-webapp-aws-terraform-locks-centralized"
    region         = "us-east-1"
    key            = "ahlorq-styles-monorepo-webapp-infra/terraform.tfstate"
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
# data "aws_region" "current" {}
