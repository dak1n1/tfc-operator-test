variable "some_string" {
  type = string
}

variable "some_list" {
  type = list(string)
}

variable "some_complex" {
  type = list(object({
    size = number
    zone = string
  }))
}

resource "aws_ebs_volume" "example" {
  for_each          = var.some_complex

  availability_zone = each.zone
  size              = each.size
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

output "some_complex" {
  value = var.some_complex
}
