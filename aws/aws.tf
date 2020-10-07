variable "testvar" {
  type = string
}

variable "some_list" {
  type = list(string)
}

variable "some_objects" {
  type = list(objects)
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 1

  tags = {
    Name = "TFC operator test"
  }
}

output "testvar" {
  value = var.testvar
}

output "some_list" {
  value = var.some_list
}

output "some_objects" {
  value = var.some_objects
}
