provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.host}"
 
  # If you have a self-signed cert
  allow_unverified_ssl = true
}
 
data "vsphere_datacenter" "dc" {
  name = "${var.region}"
}
 
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
 

resource "vsphere_virtual_disk" "myDisk" {
  size         = 2
  vmdk_path    = "${var.diskpath}"
  datacenter   = "${data.vsphere_datacenter.dc.name}"
  datastore    = "${var.datastore}"
  type         = "thin"
}

