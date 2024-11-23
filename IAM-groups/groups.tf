resource "aws_iam_group" "groups" {
  count = length(var.name)
  name = var.name[count.index]
}