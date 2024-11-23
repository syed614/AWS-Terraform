resource "aws_route_table" "route_table" {
  vpc_id = var.vpc_id
  count = length(var.Name)

  # route {
  #   cidr_block = "10.0.1.0/24"
  #   gateway_id = var.gateway_id
  # }

  tags = {
    Name = var.Name[count.index]
  }
}

# resource "aws_route_table_association" "a" {
#   subnet_id      = var.subnet_id
#   route_table_id = var.route_table_id
# }