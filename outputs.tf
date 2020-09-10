output "ip_addresses" {
    value = [
        for instance in vsphere_virtual_machine.vm:
        instance.default_ip_address
    ]

}