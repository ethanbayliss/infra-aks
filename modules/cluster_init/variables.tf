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
