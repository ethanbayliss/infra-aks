variable "ssh_rsa_key" {
  type = string
}

variable "openvpn_connector_token" {
  type      = string
  sensitive = true
}

module "openvpn_connector" {
  source = "./modules/openvpn_connector"

  name                = "${var.cluster_name}"
  resource_group_name = azurerm_resource_group.this.name
  az_location         = azurerm_resource_group.this.location

  openvpn_connector_token = var.openvpn_connector_token

  ssh_admin_ip             = var.ssh_admin_ip
  ssh_admin_rsa_public_key = var.ssh_rsa_key

  public_subnet  = azurerm_subnet.public
  private_subnet = azurerm_subnet.private

  tags = var.tags
}
