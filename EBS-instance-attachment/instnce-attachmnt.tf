resource "aws_volume_attachment" "attach_ebs" {
  count = length(var.volume_id)
  device_name = var.device_name[count.index]
  volume_id   = var.volume_id[count.index]
  instance_id = var.instance_id
}