resource "aws_ebs_volume" "example" {
  availability_zone = "us-west-2a"
  size              = 1

  tags = {
    Name = "TFC operator test"
  }
}
