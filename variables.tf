# Proxmox Provider
variable "pm_api_url" {
  type        = string
  description = "This is the target Proxmox API endpoint."
}

variable "pm_api_token_id" {
  type        = string
  description = "This is an API token you have previously created for a specific user."
  sensitive   = true
}

variable "pm_api_token_secret" {
  type        = string
  description = "(Use environment variable PM_API_TOKEN_SECRET) This uuid is only available when the token was initially created."
}

variable "pm_tls_insecure" {
  type        = bool
  description = "Disable TLS verification while connecting to the proxmox server."
  default     = true
}

variable "pm_log_enable" {
  type        = bool
  description = "Enable debug logging, see the section below for logging details."
  default     = false
}

variable "pm_log_file" {
  type        = string
  description = "If logging is enabled, the log file the provider will write logs to."
  default     = "terraform-plugin-proxmox.log"
}

variable "pm_debug" {
  type        = bool
  description = "Enable verbose output in proxmox-api-go."
  default     = false
}

variable "pm_log_levels_default" {
  type        = string
  description = "A map of log sources and levels. (_default)"
  default     = "debug"
}

variable "pm_log_levels_capturelog" {
  type        = string
  description = "A map of log sources and levels. (_capturelog)"
  default     = ""
}

# Cloud-Init
variable "ssh_authorized_keys" {
  type        = list(string)
  description = "The ssh_authorized_keys is a configuration option in cloud-init that allows you to specify a list of SSH public keys. When cloud-init runs during the instance initialization process, it adds these public keys to the ~/.ssh/authorized_keys file of the specified user, granting them SSH access to the instance."
}

# Provisioner Cloud-Init File
variable "connection_type" {
  type        = string
  description = "The connection type. Valid values are `ssh` and `winrm`. Provisioners typically assume that the remote system runs Microsoft Windows when using WinRM. Behaviors based on the SSH target_platform will force Windows-specific behavior for WinRM, unless otherwise specified."
}

variable "connection_user" {
  type        = string
  description = "The user to use for the connection."
}

variable "connection_private_key_path" {
  type        = string
  description = "The contents of an SSH key to use for the connection. These can be loaded from a file on disk using the file function. This takes preference over password if provided."
}

variable "connection_host" {
  type        = string
  description = "The address of the pve host to connect to."
}

variable "provisioner_directory_path" {
  type        = string
  description = "The directory path (without the filename) used by the provisioner."
  default     = "/var/lib/vz/snippets"
}

# Modules: vm_qemu variables
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