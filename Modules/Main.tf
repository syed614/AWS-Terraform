################   IAM users block   ###############


module "iam-users" {
  source = "../IAM-users"
  name   = ["nazeef", "shaik", "mohd"]
}


# ####################    IAM groups    #####################


module "iam-groups" {
  source = "../IAM-groups"
  name   = ["nazeef-group", "shaik-group", "mohd-group"]
}


# ###############  IAM user-group memebership   ####################


module "nazeef-user-group-membership" {
  source = "../IAM-usergroup-membership"
  name   = module.iam-users.user-names[0]
  users  = [module.iam-users.user-names[0], module.iam-users.user-names[1], module.iam-users.user-names[2]]
  group  = module.iam-groups.group-name[0]
}


#################     vpc block   ###############################


module "all-vpcs" {
  source     = "../vcn"
  Name       = ["prod-app-vcn", "prod-web-vcn"]
  cidr_block = ["10.0.0.0/16", "192.168.0.0/16"]
}


##############   subnets block ##################


module "prod-app-subnets" {
  source            = "../subnets"
  availability_zone = "us-east-2a"
  vpc_id            = module.all-vpcs.vpc_id[0]
  Name              = ["prod-app-public-subnet", "prod-app-private-subnet", "prod-app-dmz-subnet"]
  cidr_block        = ["10.0.0.0/24", "10.0.16.0/20", "10.0.128.0/25"]
}

module "prod-web-subnets" {
  source            = "../subnets"
  availability_zone = "us-east-2b"
  vpc_id            = module.all-vpcs.vpc_id[1]
  Name              = ["prod-web-dmz-subnet"]
  cidr_block        = ["192.168.0.0/25"]
}


###################   Internet gateway block  ####################


module "igw" {
  source = "../Internet_gateway"
  Name   = "igw"
  vpc_id = module.all-vpcs.vpc_id[0]
}


################ network interface (nic card) block  ################


module "nat-nwk-interface" {
  source      = "../Nwk-Interface-NAT"
  subnet_id   = module.prod-app-subnets.subnet_id[0]
  private_ips = ["10.0.0.7", "10.0.0.8"]
}


##################   elastic ip block  ###############


module "nat-eip" {
  source                    = "../Nat-gtw-eip"
  network_interface         = module.nat-nwk-interface.network_interface
  associate_with_private_ip = "10.0.0.8"
}


#############  nat gateway block  ################


module "nat-gwy" {
  source        = "../NAT"
  allocation_id = module.nat-eip.allocation_id
  subnet_id     = module.prod-web-subnets.subnet_id[0]
}


##################  route tables block   ####################


module "prod-app-route-tables" {
  source = "../route_tables"
  Name   = ["prod-app-vcn-public-rt", "prod-app-vcn-private-rt"]
  vpc_id = module.all-vpcs.vpc_id[0]
}

module "prod-web-route-tables" {
  source = "../route_tables"
  Name   = ["prod-web-rt"]
  vpc_id = module.all-vpcs.vpc_id[1]
}


###############   route tables association with subnets   ##############


module "prod-app-pub-sub-rt-association" {
  source         = "../rt_assocaiation"
  route_table_id = [module.prod-app-route-tables.route_tables[0]]
  subnet_id      = [module.prod-app-subnets.subnet_id[0]]
}

module "prod-app-private-sub-rt-association" {
  source         = "../rt_assocaiation"
  route_table_id = [module.prod-app-route-tables.route_tables[1]]
  subnet_id      = [module.prod-app-subnets.subnet_id[1]]
}

module "prod-web-rt-association" {
  source         = "../rt_assocaiation"
  route_table_id = [module.prod-web-route-tables.route_tables[0]]
  subnet_id      = [module.prod-web-subnets.subnet_id[0]]
}


#############  security groups block   ##################


module "prod-app-security-groups" {
  source = "../security_groups"
  vpc_id = module.all-vpcs.vpc_id[0]
  Name   = ["prod-app-pub-sub-sg", "prod-app-pvt-sub-sg"]
  name   = ["prod-app-pub-sub-sg", "prod-app-pvt-sub-sg"]
}

module "prod-web-security-groups" {
  source = "../security_groups"
  vpc_id = module.all-vpcs.vpc_id[1]
  Name   = ["prod-web-sg"]
  name   = ["prod-web-sg"]
}

module "prod-app-pub-sub-sg-ingress-rules" {
  source            = "../security_groups_rules"
  security_group_id = module.prod-app-security-groups.security_group_id[0]
  cidr_ipv4         = ["152.59.194.101/32"]
  from_port         = ["22"]
  to_port           = ["443"]
  ip_protocol       = ["tcp"]
}

module "prod-app-pvt-sub-sg-egress-rules" {
  source            = "../security_groups_rules"
  security_group_id = module.prod-app-security-groups.security_group_id[1]
  cidr_ipv4         = ["0.0.0.0/0"]
  from_port         = ["22"]
  to_port           = ["443"]
  ip_protocol       = ["tcp"]
}

module "prod-web-sg-ingress-rules" {
  source            = "../security_groups_rules"
  security_group_id = module.prod-web-security-groups.security_group_id[0]
  cidr_ipv4         = ["10.0.0.0/24"]
  from_port         = ["22"]
  to_port           = ["3389"]
  ip_protocol       = ["tcp"]
}



###############   virtual machines block  ###################


module "prod-app-pub-sub-ec2s" {
  source                       = "../Instance"
  subnet_id                    = module.prod-app-subnets.subnet_id[0]
  associate_public_ip_address  = [true]
  availability_zone            = "us-east-2a"
  vpc_security_group_ids       = [module.prod-app-security-groups.security_group_id[0]]
  primary_network_interface_id = module.nat-nwk-interface.network_interface
  instance_type                = ["t2.micro"]
  ami                          = ["ami-0942ecd5d85baa812"]
  source_dest_check            = [false]
  security_groups              = [module.prod-app-security-groups.security_group_id[0]]
  Name                         = ["app-01"]
  key_name                     = ["key"]
  private_ip                   = ["10.0.0.12"]
}


##################  block volumes  ####################


module "prod-app-pub-sub-vm-ebs" {
  source            = "../EBS"
  availability_zone = "us-east-2a"
  size              = [50, 55, 53]
  Name              = ["app-server-ebs01", "app-server-ebs-02", "app-server-ebs03"]
}

module "prod-app-pub-sub-ebs-attachment" {
  source      = "../EBS-instance-attachment"
  device_name = ["/dev/sdb", "/dev/sdc", "/dev/sdd"]
  instance_id = module.prod-app-pub-sub-ec2s.instance_id[0]
  volume_id   = [module.prod-app-pub-sub-vm-ebs.volume_id[0], module.prod-app-pub-sub-vm-ebs.volume_id[1], module.prod-app-pub-sub-vm-ebs.volume_id[2]]
}
