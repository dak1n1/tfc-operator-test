resource "aws_ebs_volume" "example" {
  availability_zone = var.zone
  size              = var.size
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
