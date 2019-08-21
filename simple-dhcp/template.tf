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

# Retrieve resource pool information on vsphere
data "vsphere_resource_pool" "pool" {
  name          = "${var.cluster[0]}/Resources"
datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
 

# Retrieve datastore information on vsphere
data "vsphere_datastore" "datastore" {
  name          = "${var.datastore}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Retrieve network information on vsphere
data "vsphere_network" "network" {
  name          = "${var.network_interfaces[0]}"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

# Retrieve template information on vsphere
data "vsphere_virtual_machine" "template" {
  name          = "testvm"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}
#### VM CREATION ####
# Set vm parameters
resource "vsphere_virtual_machine" "vm-one" {
  name                 = "vm-dhcp-template"
  num_cpus             = 2
  memory               = 4096
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
    label = "vm-two.vmdk"
    size = "30"
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
      linux_options {
        host_name = "vm-shweta"
        domain    = "test.internal"
      }
      network_interface {
      }
      ipv4_gateway = "10.198.4.1"
    }
  }
}

