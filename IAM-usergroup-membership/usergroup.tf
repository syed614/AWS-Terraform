resource "aws_iam_group_membership" "usergroup_membership" {
  # count = length(var.users)
  name = var.name  #[count.index]
  users = var.users #[count.index]
  group = var.group  #[count.index]
}