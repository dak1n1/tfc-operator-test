variable "some_string" {
  type = string
}

variable "some_list" {
  type = list(string)
}

variable "some_map" {
  type = list(objects)
}

resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 1

  tags = {
    Name = "TFC operator test"
  }
}

output "some_string" {
  value = var.some_string
}

output "some_list" {
  value = var.some_list
}

output "some_map" {
  value = var.some_map
}
