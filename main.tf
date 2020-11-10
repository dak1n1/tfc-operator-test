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

output "aws_ebs_volume_id" {
  value = module.aws.aws_ebs_volume_id
}
