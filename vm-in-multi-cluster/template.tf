provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.host}"
 
  # If you have a self-signed cert
  allow_unverified_ssl = true
}
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
#### RETRIEVE DATA INFORMATION ON VCENTER ####
data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

# Retrieve resource pool information on vsphere
data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster[0]}/Resources"
datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
 
data "vsphere_resource_pool" "pool2" {
  name          = "${var.cluster[1]}/Resources"
 datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "testvm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "portGroup-1004"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "vm-in-cluster1"
 resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 512
  guest_id = "centos64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

wait_for_guest_net_timeout = 0

  disk {
    label = "disk0"
    size  = 4
  }

}
resource "vsphere_virtual_machine" "vm2" {
  name             = "vm-in-cluster2"
 resource_pool_id = "${data.vsphere_resource_pool.pool2.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 512
  guest_id = "centos64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

wait_for_guest_net_timeout = 0

  disk {
    label = "disk0"
    size  = 4
  }

}
