output "ssh_host" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_vm_qemu.vms[vm_name].ssh_host
  }
  description = "Read-only attribute. Only applies when define_connection_info is true. The hostname or IP to use to connect to the VM for preprovisioning. This can be overridden by defining ssh_forward_ip, but if you're using cloud-init and ipconfig0=dhcp, the IP reported by qemu-guest-agent is used, otherwise the IP defined in ipconfig0 is used."
}

output "ssh_port" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_vm_qemu.vms[vm_name].ssh_port
  }
  description = "Read-only attribute. Only applies when define_connection_info is true. The port to connect to the VM over SSH for preprovisioning. If using cloud-init and a port is not specified in ssh_forward_ip, then 22 is used. If not using cloud-init, a port on the target_node will be forwarded to port 22 in the guest, and this attribute will be set to the forwarded port."
}

output "default_ipv4_address" {
  value = {
    for vm_name, vm_config in var.vms :
    vm_name => proxmox_vm_qemu.vms[vm_name].default_ipv4_address
  }
  description = "Read-only attribute. Only applies when agent is 1 and Proxmox can actually read the ip the vm has."
}