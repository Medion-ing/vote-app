variable "proxmox_endpoint" {
  type        = string
  description = "URL de l'API Proxmox"
  sensitive   = true
}

variable "proxmox_api_token" {
  type        = string
  description = "Token API Proxmox"
  sensitive   = true
}

variable "ssh_public_key" {
  type        = string
  description = "Clé SSH publique"
  sensitive   = true
}
