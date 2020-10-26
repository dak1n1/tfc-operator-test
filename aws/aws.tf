variable "some_string" {
  type = string
}

variable "some_list" {
  type = list(string)
}

variable "some_map" {
  type = list(object({
    size = number
    zone = string
  }))
}

resource "aws_ebs_volume" "example" {
  availability_zone = var.some_map.zone
  size              = var.some_map.size
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
