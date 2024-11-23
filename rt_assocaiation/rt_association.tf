resource "aws_route_table_association" "rt-association" {
  count = length(var.subnet_id)
  subnet_id = var.subnet_id[count.index]
  route_table_id = var.route_table_id[count.index]
}