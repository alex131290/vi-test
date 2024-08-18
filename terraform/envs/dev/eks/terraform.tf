terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.63.0"
    }
  }

  backend "s3" {
    bucket  = "vi-terraform-state-test"
    region  = "eu-west-1"
    key     = "terraform/dev-eu-west-1/eks.tfstate"
    encrypt = true
  }

  required_version = "~> 1.6"
}
