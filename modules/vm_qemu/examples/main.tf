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