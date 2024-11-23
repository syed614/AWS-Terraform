resource "aws_vpc_security_group_ingress_rule" "allow_tls_ipv4" {
  security_group_id = var.security_group_id
  # security_group_id = aws_security_group.security_group.id
  # cidr_ipv4         = aws_vpc.main.cidr_block
  count = length(var.cidr_ipv4)
  cidr_ipv4         = var.cidr_ipv4[count.index]
  from_port         = var.from_port[count.index]
  ip_protocol       = var.ip_protocol[count.index]
  to_port           = var.to_port[count.index]
}


resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4" {
  security_group_id = var.security_group_id
  count = length(var.cidr_ipv4)
  cidr_ipv4         = var.cidr_ipv4[count.index]
  from_port         = var.from_port[count.index]
  ip_protocol       = var.ip_protocol[count.index]
  to_port           = var.to_port[count.index]
}

