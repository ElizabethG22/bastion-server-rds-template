terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.75.2"
    }
  }
  backend "s3" {
    bucket         = "sainsburys-data-academy-terraform-state"
    key            = "sainsburys-data-academy-terraform-state.tfstate"
    region         = "eu-west-1"
    encrypt        = true
    dynamodb_table = "sainsburys-data-academy-terraform-state-lock"
  }

  required_version = ">= 1.1.0"
}

provider "aws" {
  region = var.region_aws
}

locals {
  prefix = "${var.prefix}-${terraform.workspace}"
  common_tags = {
    Environment = terraform.workspace
    Owner       = var.contact
    ManagedBy   = "Terraform"
  }
}

data "aws_region" "current" {}
