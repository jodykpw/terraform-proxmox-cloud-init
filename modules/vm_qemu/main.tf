resource "local_file" "cloud_init_user_data_file" {
  for_each = var.vms

  filename = "${path.module}/files/vm-${each.key}-cloud-init.cfg"
  content  = <<EOF
#cloud-config
hostname: ${each.value.hostname}
manage_etc_hosts: ${each.value.manage_etc_hosts}
fqdn: ${each.value.fqdn}
timezone: ${each.value.timezone}
users:
  - name: ${each.value.username}
    ssh-authorized-keys:
    ${join("\n", ["  - ${join("\n      - ", each.value.ssh_authorized_keys)}"])}
    sudo: ${each.value.sudo_config}
    groups: sudo
    shell: /bin/bash
package_upgrade: ${each.value.package_upgrade}
${length(each.value.packages) > 0 ? "packages:\n${join("\n", [for pkg in each.value.packages : "  - ${pkg}"])}" : ""}
${length(each.value.runcmd) > 0 ? "runcmd:\n${join("\n", [for cmd in each.value.runcmd : "  - ${cmd}"])}" : ""}
EOF  
}

resource "null_resource" "cloud_init_config_files" {
  for_each = var.vms

  connection {
    type     = "ssh"
    host     = var.ssh_host
    user     = var.ssh_user
    password = var.ssh_password
  }

  provisioner "file" {
    source      = local_file.cloud_init_user_data_file[each.key].filename
    destination = "${var.provisioner_directory_path}/snippets/vm-${each.key}-cloud-init.yaml"
  }
}

resource "proxmox_vm_qemu" "vms" {
  for_each = var.vms

  target_node = each.value.target_node
  vmid        = each.value.vmid
  name        = each.key
  clone       = each.value.clone
  full_clone  = each.value.full_clone
  pool        = each.value.pool
  desc        = each.value.desc

  memory  = each.value.memory
  numa    = each.value.numa
  sockets = each.value.sockets
  cores   = each.value.cores
  cpu     = each.value.cpu
  scsihw  = each.value.scsihw

  onboot   = each.value.onboot
  os_type  = each.value.os_type
  bootdisk = each.value.bootdisk
  hotplug  = each.value.hotplug
  agent    = each.value.agent

  vga {
    type = each.value.vga_type
    # Between 4 and 512, ignored if type is defined to serial
    memory = each.value.vga_memory
  }

  dynamic "disk" {
    for_each = each.value.disks
    content {
      type     = disk.value.type
      storage  = disk.value.storage
      size     = disk.value.size
      iothread = disk.value.iothread
      ssd      = disk.value.ssd
    }
  }

  dynamic "network" {
    for_each = each.value.networks
    content {
      model    = network.value.model
      bridge   = network.value.bridge
      tag      = network.value.tag
      firewall = network.value.firewall
    }
  }

  # Cloud-Init
  ipconfig0 = each.value.ipconfig0
  cicustom  = "user=${each.value.cicustom_volume}:snippets/vm-${each.key}-cloud-init.yaml"
}
