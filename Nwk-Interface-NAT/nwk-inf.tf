resource "aws_network_interface" "multi-ip" {
  subnet_id   = var.subnet_id
  private_ips = var.private_ips
}