terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = "us-west-2"
}

# These variables are used to test populating terraform
# variables into TFC from the Workspace CR.
variable "some_string" {
  type    = string
  default = "test"
}

variable "some_list" {
  type    = list(string)
  default = ["hello", "world"]
}

variable "some_map" {
  type    = map
  default = {
      "size" = 2
      "zone" = "us-west-2a"
  }
}

module "aws" {
  source       = "./aws"
  some_string  = var.some_string
  some_list    = var.some_list
  some_map     = var.some_map
}
