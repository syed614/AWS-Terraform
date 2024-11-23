resource "aws_iam_user" "user" {
  count = length(var.name)
  name = var.name[count.index]
}