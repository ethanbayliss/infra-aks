variable "name" {
  type     = string
  default  = "openvpn_connector"
  nullable = false
}

variable "resource_group_name" {
  type     = string
  nullable = false
}

variable "az_location" {
  type     = string
  nullable = false
}

variable "openvpn_connector_token" {
  type        = string
  description = "Create a CloudConnexa connector at https://<tenant id>.openvpn.com/networks/connectors > Deploy > Copy .ovpn connector token"
  nullable    = false
}

variable "ssh_admin_ip" {
  type     = string
  default  = "127.0.0.1/32"
  nullable = false
}

variable "ssh_admin_rsa_public_key" {
  type     = string
  nullable = false
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
  nullable = false
}

variable "source_image_reference" {
  default = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }
  nullable = false
}

variable "public_subnet" {
  nullable = false
}

variable "private_subnet" {
  nullable = false
}

variable "tags" {
  nullable = true
}
