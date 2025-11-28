# Configuration de base
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.82.0"
    }
  }
}

# Connexion à Proxmox
provider "proxmox" {
  endpoint  = var.proxmox_endpoint    # URL de Proxmox
  api_token = var.proxmox_api_token   # Token secret
  insecure  = true
}
