# output "network_interface" {
#   value = aws_network_interface.multi-ip.id
# }

output "allocation_id" {
  value = aws_eip.one.id
}