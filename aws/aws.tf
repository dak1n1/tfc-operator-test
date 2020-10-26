resource "aws_ebs_volume" "example" {
  availability_zone = var.zone
  size              = var.size
  tags = {
    Name = "TFC operator test"
  }
}

output "aws_ebs_volume_id" {
  value = aws_ebs_volume.example.id
}
