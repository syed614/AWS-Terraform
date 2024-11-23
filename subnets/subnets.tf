resource "aws_subnet" "subnet" {
  count = length(var.cidr_block)
  vpc_id     = var.vpc_id
  availability_zone = var.availability_zone
  cidr_block = var.cidr_block[count.index]

  tags = {
    Name = var.Name[count.index]
  }
}