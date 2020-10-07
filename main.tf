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
      "size" = 10
      "type" = "ssd"
      "zone" = "us-west-2a"
  }
}

module "aws" {
  source       = "./aws"
  testvar      = var.testvar
  some_list    = var.some_list
  some_objects = var.some_objects
}
