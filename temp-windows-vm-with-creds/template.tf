provider "vsphere" {
  user           = "cmpqa.svc@itomcmp.servicenow.com"
  password       = "snc!23$"
  vsphere_server = "10.198.1.13"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "devcloud"
}

data "vsphere_datastore" "datastore" {
  name          = "vmstore"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "fenrir/Resources"
 datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "portGroup-1004"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_virtual_machine" "template" {
  name          = "windows-terraform-test"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

resource "vsphere_virtual_machine" "vm" {
  name             = "shwe-windows-terraform-test"
 resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 512
  guest_id = "windows7_64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

wait_for_guest_net_timeout = 0

  disk {
    label = "disk0"
    size  = 4
  }
  clone {
    template_uuid = "${data.vsphere_virtual_machine.template.id}"
    customize {
     

      windows_options {
        computer_name  = "shweta-terraform-test"
        workgroup      = "test"
        admin_password = "test123"
      }
    }
  }
}


