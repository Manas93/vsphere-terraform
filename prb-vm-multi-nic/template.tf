provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.host}"
 
  # If you have a self-signed cert
  allow_unverified_ssl = true
}
 
data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}
 
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
 
data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster}/Resources"
datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "testvm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network2" {
  name          = "${var.network_interfaces[1]}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
 
data "vsphere_network" "network" {
  name          = "${var.network_interfaces[0]}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
 
resource "vsphere_virtual_machine" "vm" {
  name             = "test-mulitnic-vm"
 resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 512
  guest_id = "centos64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }
  network_interface {
    network_id = "${data.vsphere_network.network2.id}"
  }

wait_for_guest_net_timeout = 0

  disk {
    label = "disk0"
    size  = 4
  }
}
