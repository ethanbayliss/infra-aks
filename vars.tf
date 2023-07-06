variable "tags" {
  default = {
    iac         = "terraform"
    iac_repo    = "https://github.com/ethanbayliss/infra-aks"
    environment = "sandbox"
  }
}

variable "location" {
  type = string
  default = "Australia East"
}

variable "default_node_pool" {
  type = object

  default = {
    name            = "burstable"
    node_count      = 2
    vm_size         = "Standard_B4ms"
    os_disk_size_gb = 60
  }
}
