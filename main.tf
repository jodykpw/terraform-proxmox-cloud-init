module "proxmox_vms" {
  source = "./modules/vm_qemu"

  connection_type             = var.connection_type
  connection_user             = var.connection_user
  connection_host             = var.connection_host
  connection_private_key_path = var.connection_private_key_path
  provisioner_directory_path  = var.provisioner_directory_path

  vms = {
    "docker-1" = {
      ipconfig0           = "ip=10.1.5.161/24,gw=10.1.5.1,ip6=dhcp"
      cicustom_volume     = "pve-cluster-fs"
      hostname            = "docker-1"
      manage_etc_hosts    = true
      fqdn                = "docker-1.jodywan.com"
      timezone            = "Europe/London"
      username            = "centos"
      ssh_authorized_keys = var.ssh_authorized_keys
      sudo_config         = "['ALL=(ALL) NOPASSWD:ALL']"
      package_upgrade     = false
      packages            = []
      runcmd              = []
      # VMS
      target_node = "pve2"
      vmid        = 0
      clone       = "template-centos8-cloud-image-20230501"
      full_clone  = true
      pool        = ""
      desc        = "A self-hosting GitLab Omnibus using Docker containers on a single machine."
      memory      = 4096
      numa        = false
      sockets     = 1
      cores       = 4
      cpu         = "host"
      scsihw      = "virtio-scsi-single"
      onboot      = false
      os_type     = "cloud-init"
      bootdisk    = "scsi0"
      hotplug     = "network,disk,usb"
      agent       = 1
      vga_type    = "std"
      # Between 4 and 512, ignored if type is defined to serial
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
          firewall = false
        }
      ]
    } // End: docker-1
  }   // End: vms
}