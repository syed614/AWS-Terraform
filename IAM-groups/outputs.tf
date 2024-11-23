output "group-name" {
  value = aws_iam_group.groups.*.id
}