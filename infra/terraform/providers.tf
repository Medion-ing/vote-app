terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "~> 0.82.0" # dernière version stable
    }
  }
  required_version = ">= 1.0.0"
}

provider "proxmox" {
  endpoint  = "https://192.168.1.42:8006/api2/json"
  api_token = "terraform-prov@pam!terraform-token=7bf8551d-e898-41ea-9d05-d9ec1b838f13"
  insecure  = true
}