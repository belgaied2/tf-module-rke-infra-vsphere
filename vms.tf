data "vsphere_datacenter" "dc" {
  name = "RNCH-HE-FMT"
}

data "vsphere_datastore" "datastore" {
  name          = "ranch01-silo01-vm01"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = "mbh"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_network" "network" {
  name          = "Private Range 172.16.128.1-21"
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_virtual_machine" "template" {
  name          = var.vm_template
  datacenter_id = data.vsphere_datacenter.dc.id
}

resource "vsphere_virtual_machine" "vm" {
  count = var.vm_count
  name             = "rancher-ha-${count.index}"
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id

  num_cpus = 2
  memory   = 8192
  guest_id = "rhel7_64Guest"

  network_interface {
    network_id = data.vsphere_network.network.id
  }

  disk {
    label = "disk0"
    size  = 20
    thin_provisioned = false
  }

  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
  }

  provisioner "remote-exec" {
    connection {
      type     = "ssh"
      user     = "rancher"
      private_key = file(var.private_key)
      host     = self.default_ip_address
    }
    inline = [
      "sudo systemctl stop firewalld",
      "sudo systemctl disable firewalld",
      "sudo systemctl restart docker"
    ]
  }
}
