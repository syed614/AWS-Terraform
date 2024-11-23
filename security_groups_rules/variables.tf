variable "security_group_id" {
  
}

variable "cidr_ipv4" {
  type = list(string)
}

variable "from_port" {
  type = list(string)
}

variable "to_port" {
  type = list(string)
}

variable "ip_protocol" {
  type = list(string)
}