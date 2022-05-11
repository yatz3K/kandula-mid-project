terraform {
  required_providers {
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
      version = ">=2.7.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.68.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1.0"
    }
    template = {
      source  = "hashicorp/template"
      version = "~> 2.2.0"
    }

  }
}
provider "aws" {
  profile = "default"
  region  = var.aws_region
}
