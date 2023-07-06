variable "tags" {
  default = {
    iac         = "terraform"
    iac_repo    = "https://github.com/ethanbayliss/infra-aks"
    environment = "sandbox"
  }
}

variable "location" {
  type    = string
  default = "Australia East"
}

variable "default_node_pool" {
  type = object({
    name            = string
    node_count      = number
    vm_size         = string
    os_disk_size_gb = number
  })

  default = {
    name            = "burstable"
    node_count      = 2
    vm_size         = "Standard_B4ms"
    os_disk_size_gb = 60
  }
}

variable "cluster_domain_name" {
  type    = string
  default = "k8s.ethan.network"
}

# See https://learn.microsoft.com/en-us/azure/aks/supported-kubernetes-versions?tabs=azure-cli#aks-kubernetes-release-calendar
variable "kubernetes_version" {
  type    = string
  default = "1.27"
}
