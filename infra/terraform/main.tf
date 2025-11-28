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

# Liste de mes VMs
locals {
  mes_vms = {
    "k8s-master"  = { ip = "192.168.1.180" },
    "k8s-worker1" = { ip = "192.168.1.181" }, 
    "k8s-worker2" = { ip = "192.168.1.182" }
  }
}

# Création des VMs
resource "proxmox_virtual_environment_vm" "cluster_k8s" {
  for_each = local.mes_vms

  name      = each.key
  node_name = "pve"

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  clone {
    vm_id = 100
  }

  disk {
    datastore_id = "local"
    interface    = "scsi0"
    size         = 150
  }

  network_device {
    bridge = "vmbr0"
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = [var.ssh_public_key]   # Clé SSH secrète
    }

    ip_config {
      ipv4 {
        address = "${each.value.ip}/24"
        gateway = "192.168.1.1"
      }
    }

    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }
  }
}
