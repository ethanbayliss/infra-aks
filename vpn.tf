variable "ssh_rsa_key" {
  type = string
}

variable "openvpn_connector_token" {
  type      = string
  sensitive = true
}

module "openvpn_connector" {
  source = "./modules/openvpn_connector"

  name                = "${terraform.workspace}-vpn"
  resource_group_name = azurerm_resource_group.this.name
  az_location         = azurerm_resource_group.this.location

  openvpn_connector_token = var.openvpn_connector_token

  ssh_admin_ip             = "127.0.0.1/32"
  ssh_admin_rsa_public_key = var.ssh_rsa_key

  vm_size                = "Standard_B1s"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  public_subnet  = azurerm_subnet.public
  private_subnet = azurerm_subnet.private

  tags = var.tags
}
