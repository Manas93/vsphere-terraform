provider "vsphere" {
  user           = "${var.user}"
  password       = "${var.password}"
  vsphere_server = "${var.host}"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}
#### RETRIEVE DATA INFORMATION ON VCENTER ####
data "vsphere_datacenter" "dc" {
  name = "${var.region}"
}
data "vsphere_resource_pool" "pool" {
  name          = "${var.resourcepool}/Resources"
 datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
# Retrieve datastore information on vsphere
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
# Retrieve network information on vsphere
data "vsphere_network" "network" {
  name          = "${var.network_name}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
# Retrieve template information on vsphere
data "vsphere_virtual_machine" "template" {
  name          = "${var.image}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
#### VM CREATION ####
# Set vm parameters
resource "vsphere_virtual_machine" "vm-one" {
  name                 = "${var.vmname}"
  num_cpus             = "${var.num_cpus}"
  memory               = "${var.memory}"
  datastore_id         = "${data.vsphere_datastore.datastore.id}"
  #host_system_id       = "${data.vsphere_host.host.id}"
  resource_pool_id     = "${data.vsphere_resource_pool.pool.id}"
  guest_id             = "${data.vsphere_virtual_machine.template.guest_id}"
  scsi_type            = "${data.vsphere_virtual_machine.template.scsi_type}"
  # Set network parameters
  network_interface {
    network_id         = "${data.vsphere_network.network.id}"
  }
  # Use a predefined vmware template has main disk
  disk {
    label = "${var.diskname}.vmdk"
    size = "30"
    thin_provisioned = "${data.vsphere_virtual_machine.template.disks.0.thin_provisioned}"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "${var.hostname}"
        domain    = "${var.domain}"
      }
      network_interface {
        ipv4_address    = "${var.ipv4_address}"
        ipv4_netmask    = "${var.ipv4_netmask}"
        dns_server_list = "${var.dns_server_list}"
      }
      ipv4_gateway = "${var.ipv4_gateway}"
    }
  }
}
