<!-- BEGIN_TF_DOCS -->
# Terraform Proxmox Cloud-Init Modules

This repository contains Terraform modules for provisioning virtual machines on Proxmox using Cloud-Init for configuration management. The modules provide reusable and configurable components that can be used to define and deploy virtual machines in a Proxmox environment.

#### Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 2.9.14 |

#### Providers

| Name | Version |
|------|---------|
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 2.9.14 |

#### Modules

No modules.

#### Resources

| Name | Type |
|------|------|
| [local_file.cloud_init_user_data_file](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [null_resource.cloud_init_config_files](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [proxmox_vm_qemu.vms](https://registry.terraform.io/providers/telmate/proxmox/2.9.14/docs/resources/vm_qemu) | resource |

#### Inputs

| Name | Description | Type |
|------|-------------|------|
| <a name="input_ssh_host"></a> [ssh\_host](#input\_ssh\_host) | IP address of the remote host | `string` |
| <a name="input_ssh_password"></a> [ssh\_password](#input\_ssh\_password) | SSH password | `string` |
| <a name="input_ssh_user"></a> [ssh\_user](#input\_ssh\_user) | The address of the pve host to connect to. | `string` |
| <a name="input_provisioner_directory_path"></a> [provisioner\_directory\_path](#input\_provisioner\_directory\_path) | The directory path (without the filename) used by the provisioner. | `string` |
| <a name="input_vms"></a> [vms](#input\_vms) | Map of virtual machines to create | <pre>map(object({<br>    ipconfig0           = string<br>    cicustom_volume     = string<br>    hostname            = string<br>    manage_etc_hosts    = bool<br>    fqdn                = string<br>    timezone            = string<br>    username            = string<br>    ssh_authorized_keys = list(string)<br>    sudo_config         = string<br>    package_upgrade     = bool<br>    packages            = list(string)<br>    runcmd              = list(string)<br>    target_node         = string<br>    vmid                = number<br>    clone               = string<br>    full_clone          = bool<br>    pool                = string<br>    desc                = string<br>    memory              = number<br>    numa                = bool<br>    sockets             = number<br>    cores               = number<br>    cpu                 = string<br>    scsihw              = string<br>    onboot              = bool<br>    os_type             = string<br>    bootdisk            = string<br>    hotplug             = string<br>    agent               = number<br>    vga_type            = string<br>    vga_memory          = number<br>    disks = list(object({<br>      type     = string<br>      storage  = string<br>      size     = string<br>      iothread = number<br>      ssd      = number<br>    }))<br>    networks = list(object({<br>      model    = string<br>      bridge   = string<br>      tag      = number<br>      firewall = bool<br>    }))<br>  }))</pre> |
For a complete list of inputs and their descriptions for the Proxmox provider, refer to the [Proxmox Provider Documentation](https://registry.terraform.io/providers/Telmate/proxmox/latest/docs).

#### Outputs

| Name | Description |
|------|-------------|
| <a name="output_default_ipv4_address"></a> [default\_ipv4\_address](#output\_default\_ipv4\_address) | Read-only attribute. Only applies when agent is 1 and Proxmox can actually read the ip the vm has. |
| <a name="output_ssh_host"></a> [ssh\_host](#output\_ssh\_host) | Read-only attribute. Only applies when define\_connection\_info is true. The hostname or IP to use to connect to the VM for preprovisioning. This can be overridden by defining ssh\_forward\_ip, but if you're using cloud-init and ipconfig0=dhcp, the IP reported by qemu-guest-agent is used, otherwise the IP defined in ipconfig0 is used. |
| <a name="output_ssh_port"></a> [ssh\_port](#output\_ssh\_port) | Read-only attribute. Only applies when define\_connection\_info is true. The port to connect to the VM over SSH for preprovisioning. If using cloud-init and a port is not specified in ssh\_forward\_ip, then 22 is used. If not using cloud-init, a port on the target\_node will be forwarded to port 22 in the guest, and this attribute will be set to the forwarded port. |

#### Usage
```hcl
variable "vms" {
  description = "Map of virtual machines to create"
  type = map(object({
    ipconfig0           = string
    cicustom_volume     = string
    hostname            = string
    manage_etc_hosts    = bool
    fqdn                = string
    timezone            = string
    username            = string
    ssh_authorized_keys = list(string)
    sudo_config         = string
    package_upgrade     = bool
    packages            = list(string)
    runcmd              = list(string)
    target_node         = string
    vmid                = number
    clone               = string
    full_clone          = bool
    pool                = string
    desc                = string
    memory              = number
    numa                = bool
    sockets             = number
    cores               = number
    cpu                 = string
    scsihw              = string
    onboot              = bool
    os_type             = string
    bootdisk            = string
    hotplug             = string
    agent               = number
    vga_type            = string
    vga_memory          = number
    disks = list(object({
      type     = string
      storage  = string
      size     = string
      iothread = number
      ssd      = number
    }))
    networks = list(object({
      model    = string
      bridge   = string
      tag      = number
      firewall = bool
    }))
  }))

  default = {
    example_vm = {
      # Cloud-Init
      ipconfig0           = "ip=192.168.1.10/24,gw=192.168.1.1,ip6=dhcp"
      cicustom_volume     = "local"
      hostname            = "example"
      manage_etc_hosts    = true
      fqdn                = "example.com"
      timezone            = "UTC"
      username            = "exampleuser"
      ssh_authorized_keys = []
      sudo_config         = ""
      package_upgrade     = false
      packages            = []
      runcmd              = []
      # VMS
      target_node = "pve"
      vmid        = 0
      clone       = "template"
      full_clone  = true
      pool        = "default"
      desc        = ""
      memory      = 2048
      numa        = false
      sockets     = 1
      cores       = 2
      cpu         = "host"
      scsihw      = "virtio-scsi-single"
      onboot      = true
      os_type     = "cloud-init"
      bootdisk    = "scsi0"
      hotplug     = "network,disk,usb"
      agent       = 1
      # Between 4 and 512, ignored if type is defined to serial
      vga_type   = "serial0"
      vga_memory = 128
      disks = [
        {
          type     = "scsi"
          storage  = "local-lvm"
          size     = "100G"
          iothread = 1
          ssd      = 1
        },
        {
          type     = "scsi"
          storage  = "local-lvm"
          size     = "30G"
          iothread = 1
          ssd      = 1
        }
      ]
      networks = [
        {
          model    = "virtio"
          bridge   = "vmbr0"
          tag      = -1
          firewall = true
        }
      ]
    }
  }
}
```

## 📜 License

MIT

## 🇬🇧🇭🇰 Author Information

* Author: Jody WAN
* Linkedin: https://www.linkedin.com/in/jodywan/
* Website: https://www.jodywan.com
<!-- END_TF_DOCS -->