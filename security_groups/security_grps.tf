resource "aws_security_group" "security_group" {
  count = length(var.Name)
  name        = var.name[count.index]
  vpc_id      = var.vpc_id

  tags = {
    Name = var.Name[count.index]
  }
}

