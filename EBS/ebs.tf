resource "aws_ebs_volume" "ebs" {
  count = length(var.size)
  availability_zone = var.availability_zone
  size              = var.size[count.index]

  tags = {
    Name = var.Name[count.index]
  }
}