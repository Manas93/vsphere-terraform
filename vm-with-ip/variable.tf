variable "datastore" {
 type = "string"
}

variable "memory" {
   default = 4096
}

variable "num_cpus" {
  default = 2
}

variable "domain" {
  default = "test.internal"
}

variable "vmname" {
 type = "string"
}
variable "image" {
  type = "string"
}
variable "network_name" {
  type = "string"
}
variable "diskname" {
  type = "string"
}
variable "hostname" {
 type = "string"
 default = "vm-two"
}
variable "resourcepool" {
  type = "string"
}
variable "ipv4_address" {
  type = "string"
  default = "10.198.4.157"
}
variable "ipv4_netmask" {
  default = 24
}
variable "ipv4_gateway" {
  type = "string"
  default = "10.198.4.1"
}
variable "dns_server_list" {
  type = "list"
  default = ["10.198.4.10"]
}
variable "user" {
    type = "string"
}
variable "password" {
    type = "string"
}
variable "host" {
    type = "string"
}
variable "region" {
    type = "string"
}
