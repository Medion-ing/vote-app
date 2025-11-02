# 1. Créer la VM master en clonant le template
resource "proxmox_virtual_environment_vm" "k8s_master" {
  name      = "k8s-master"
  node_name = "pve"
  tags      = ["kubernetes", "master"]

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  operating_system {
    type = "l26"
  }

  # CLONER le template au lieu d'utiliser file_id
  clone {
    vm_id = 100  # ID du template
  }

  # Disk pour les données (en plus du clone)
  disk {
    datastore_id = "local"
    interface    = "scsi0"
    size         = 150
    file_format  = "raw"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTuRwfhJHQbvhydIyQNAfC61S67A8c0hGu7oqnr1zAv859KPXl94dzx6vb0eLCqy7cMm1MXuxTzPO4aicLzh+/EmppLHn8SfM+Dpx5ws83fL4BB9emWOSc6V8hvVHYrE6apORauhmPf5L6jsqNOcNgwJqn8vdhSuAE/e668SkyWxv3JJR0EOcWanNIweU9xD/10XFuTvZ3jj+Wnq0sHejeymC9Eo8L55tTneVYte6kvAuowSSn6MguBIpWApZEOZ8rYjcQZ8R7SoY5I33NFoC0P3mRNK/PDza51JGPKccaTLS1ki+xjZaw4+ZKOD9W0FBvFjafPlJxEXd+EjYGo+7Kn1ekDEEYxuMdgdAbZnhusTcH6cw/WQkI4+lzZNH5620k9bM5LTsEZyj/S91Jqj9Zwu1VNUkQYqM8hsh86j1ZVcQgAO/Ob8q64EzmtI+2mmB15AyB5zug/N/Jfj67l/BqxjTlAjlPpmiBkydkORSgsBCI25VPBTtVROS7g+QRULUzUEPNPb4PrOgyc1weXcuSWJlTOE7SUTrKqU2VR1maYMHx90Rik9NCUHFgsgD51XG1/e1VuMmPR6jMhGSkT9WFqOOVJJfwSlAu3bJ/Pih9T7+1LEY6DoyPqpDVWo4x1KQgcx2U5YmrGmPFLIILwjgon+ziWz3kec7JEvBWOE4Rpw== terraform-proxmox"]
    }

    ip_config {
      ipv4 {
        address = "192.168.1.180/24"
        gateway = "192.168.1.1"
      }
    }

    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }
  }
}

# 2. Créer la VM worker1 en clonant le template
resource "proxmox_virtual_environment_vm" "k8s_worker1" {
  name      = "k8s-worker1"
  node_name = "pve"
  tags      = ["kubernetes", "worker"]

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  operating_system {
    type = "l26"
  }

  clone {
    vm_id = 100
  }

  disk {
    datastore_id = "local"
    interface    = "scsi0"
    size         = 150
    file_format  = "raw"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTuRwfhJHQbvhydIyQNAfC61S67A8c0hGu7oqnr1zAv859KPXl94dzx6vb0eLCqy7cMm1MXuxTzPO4aicLzh+/EmppLHn8SfM+Dpx5ws83fL4BB9emWOSc6V8hvVHYrE6apORauhmPf5L6jsqNOcNgwJqn8vdhSuAE/e668SkyWxv3JJR0EOcWanNIweU9xD/10XFuTvZ3jj+Wnq0sHejeymC9Eo8L55tTneVYte6kvAuowSSn6MguBIpWApZEOZ8rYjcQZ8R7SoY5I33NFoC0P3mRNK/PDza51JGPKccaTLS1ki+xjZaw4+ZKOD9W0FBvFjafPlJxEXd+EjYGo+7Kn1ekDEEYxuMdgdAbZnhusTcH6cw/WQkI4+lzZNH5620k9bM5LTsEZyj/S91Jqj9Zwu1VNUkQYqM8hsh86j1ZVcQgAO/Ob8q64EzmtI+2mmB15AyB5zug/N/Jfj67l/BqxjTlAjlPpmiBkydkORSgsBCI25VPBTtVROS7g+QRULUzUEPNPb4PrOgyc1weXcuSWJlTOE7SUTrKqU2VR1maYMHx90Rik9NCUHFgsgD51XG1/e1VuMmPR6jMhGSkT9WFqOOVJJfwSlAu3bJ/Pih9T7+1LEY6DoyPqpDVWo4x1KQgcx2U5YmrGmPFLIILwjgon+ziWz3kec7JEvBWOE4Rpw== terraform-proxmox"]
    }

    ip_config {
      ipv4 {
        address = "192.168.1.181/24"
        gateway = "192.168.1.1"
      }
    }

    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }
  }
}

# 3. Créer la VM worker2 en clonant le template
resource "proxmox_virtual_environment_vm" "k8s_worker2" {
  name      = "k8s-worker2"
  node_name = "pve"
  tags      = ["kubernetes", "worker"]

  cpu {
    cores = 2
  }

  memory {
    dedicated = 4096
  }

  operating_system {
    type = "l26"
  }

  clone {
    vm_id = 100
  }

  disk {
    datastore_id = "local"
    interface    = "scsi0"
    size         = 150
    file_format  = "raw"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  initialization {
    user_account {
      username = "ubuntu"
      keys     = ["ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDTuRwfhJHQbvhydIyQNAfC61S67A8c0hGu7oqnr1zAv859KPXl94dzx6vb0eLCqy7cMm1MXuxTzPO4aicLzh+/EmppLHn8SfM+Dpx5ws83fL4BB9emWOSc6V8hvVHYrE6apORauhmPf5L6jsqNOcNgwJqn8vdhSuAE/e668SkyWxv3JJR0EOcWanNIweU9xD/10XFuTvZ3jj+Wnq0sHejeymC9Eo8L55tTneVYte6kvAuowSSn6MguBIpWApZEOZ8rYjcQZ8R7SoY5I33NFoC0P3mRNK/PDza51JGPKccaTLS1ki+xjZaw4+ZKOD9W0FBvFjafPlJxEXd+EjYGo+7Kn1ekDEEYxuMdgdAbZnhusTcH6cw/WQkI4+lzZNH5620k9bM5LTsEZyj/S91Jqj9Zwu1VNUkQYqM8hsh86j1ZVcQgAO/Ob8q64EzmtI+2mmB15AyB5zug/N/Jfj67l/BqxjTlAjlPpmiBkydkORSgsBCI25VPBTtVROS7g+QRULUzUEPNPb4PrOgyc1weXcuSWJlTOE7SUTrKqU2VR1maYMHx90Rik9NCUHFgsgD51XG1/e1VuMmPR6jMhGSkT9WFqOOVJJfwSlAu3bJ/Pih9T7+1LEY6DoyPqpDVWo4x1KQgcx2U5YmrGmPFLIILwjgon+ziWz3kec7JEvBWOE4Rpw== terraform-proxmox"]
    }

    ip_config {
      ipv4 {
        address = "192.168.1.182/24"
        gateway = "192.168.1.1"
      }
    }

    dns {
      servers = ["8.8.8.8", "1.1.1.1"]
    }
  }
}