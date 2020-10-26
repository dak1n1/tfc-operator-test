terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

module "aws" {
  source = "./aws"
  zone   = var.zone
  size   = var.size
}
