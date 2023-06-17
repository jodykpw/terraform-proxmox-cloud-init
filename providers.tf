terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.14"
    }
  }
}

provider "proxmox" {
  pm_api_url          = var.pm_api_url
  pm_api_token_id     = var.pm_api_token_id
  pm_api_token_secret = var.pm_api_token_secret
  pm_tls_insecure     = var.pm_tls_insecure

  pm_log_enable = var.pm_log_enable
  pm_log_file   = var.pm_log_file
  pm_debug      = var.pm_debug
  pm_log_levels = {
    _default    = var.pm_log_levels_default
    _capturelog = var.pm_log_levels_capturelog
  }
}