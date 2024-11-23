output "user-names" {
  value = aws_iam_user.user.*.id
}

