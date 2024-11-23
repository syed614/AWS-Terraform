# resource "aws_instance" "instance" {
#   availability_zone = var.availability_zone
#   ami                          = var.ami[count.index]
#   associate_public_ip_address  = var.associate_public_ip_address[count.index]
#   subnet_id                    = var.subnet_id
#   security_groups              = var.security_groups
#   count = length(var.instance_type)
#   instance_type                = var.instance_type[count.index]
#   private_ip                   = var.private_ip[count.index]
#   source_dest_check            = var.source_dest_check[count.index]
#   vpc_security_group_ids       = var.vpc_security_group_ids

#   tags = {
#     Name = var.Name[count.index]
#   }
# }


resource "aws_instance" "example_server" {
  count = length(var.ami)
  ami           = var.ami[count.index]
  availability_zone = var.availability_zone
  associate_public_ip_address  = var.associate_public_ip_address[count.index]
  subnet_id                    = var.subnet_id
  security_groups              = var.security_groups
  instance_type = var.instance_type[count.index]
  vpc_security_group_ids       = var.vpc_security_group_ids
  private_ip                   = var.private_ip[count.index]

  tags = {
    Name = var.Name[count.index]
  }
}