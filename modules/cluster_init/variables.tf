variable "name" {
  type     = string
  default  = "kubernetes-init"
  nullable = false
}

variable "resource_group_name" {
  type     = string
  nullable = false
}

variable "location" {
  type     = string
  nullable = false
}

variable "subnet_id" {
  type = string
}

variable "input_manifests" {
  type = set(string)
}

variable "tags" {
}

variable "address_space" {
  default = {
    parent_subnet  = "10.70.0.0/16"
    private_subnet = "10.70.8.0/21"
  }
}

variable "kubernetes_version" {
  type = string
}
