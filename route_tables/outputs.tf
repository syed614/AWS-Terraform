output "route_tables" {
  value = aws_route_table.route_table.*.id
}