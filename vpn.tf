variable "ssh_rsa_key" {
  type = string
}

module "openvpn_connector" {
  source = "./modules/openvpn_connector"

  name                = "${terraform.workspace}-vpn"
  resource_group_name = azurerm_resource_group.this.name
  az_location         = azurerm_resource_group.this.location
  openvpn_region_id   = "Sydney"

  ssh_admin_ip             = "127.0.0.1/32"
  ssh_admin_rsa_public_key = var.ssh_rsa_key

  vm_size                = "Standard_B1s"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  public_subnet_id  = azurerm_subnet.public.id
  private_subnet_id = azurerm_subnet.private.id

  tags = var.tags
}
