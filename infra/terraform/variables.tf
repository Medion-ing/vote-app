variable "proxmox_endpoint" {
  type        = string
  description = "L'URL de mon Proxmox"
}

variable "proxmox_api_token" {
  type        = string
  description = "Le token pour se connecter à Proxmox"
  sensitive   = true   # Cache la valeur dans les logs
}

variable "ssh_public_key" {
  type        = string
  description = "Ma clé SSH publique"
  sensitive   = true   # Cache la valeur dans les logs
}
