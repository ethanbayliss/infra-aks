variable "name" {
  type    = string
  default = "openvpn_connector"
}

variable "resource_group_name" {
  type = string
}

variable "az_location" {
  type = string
}

variable "openvpn_region_id" {
  type    = string
}

variable "ssh_admin_ip" {
  type    = string
  default = "127.0.0.1/32"
}

variable "ssh_admin_rsa_public_key" {
  type = string
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "source_image_reference" {
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
}

variable "public_subnet_id" {
  type = string
}

variable "private_subnet_id" {
  type = string
}

variable "tags" {
}
