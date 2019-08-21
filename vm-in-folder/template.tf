provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.host}"
 
  # If you have a self-signed cert
  allow_unverified_ssl = true
}

#### RETRIEVE DATA INFORMATION ON VCENTER ####
data "vsphere_datacenter" "dc" {
  name = "${var.datacenter}"
}

resource "vsphere_folder" "folder" {
  path          = "test-vm-folder"
  type          = "vm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Retrieve datastore information on vsphere
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Retrieve resource pool information on vsphere
data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster[0]}/Resources"
datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "terraform-test01"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Retrieve network information on vsphere
data "vsphere_network" "network" {
  name          = "${var.network_interfaces[0]}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
resource "vsphere_virtual_machine" "vm" {
  name             = "vm-in-folder"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  folder = "test-vm-folder"
 
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
