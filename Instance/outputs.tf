output "instance_id" {
  value = aws_instance.example_server.*.id
}

