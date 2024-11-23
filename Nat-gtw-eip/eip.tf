resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = var.network_interface
  associate_with_private_ip = var.associate_with_private_ip
}