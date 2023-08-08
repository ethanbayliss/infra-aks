resource "azurerm_dns_zone" "public_zone" {
  name                = "${terraform.workspace}.${var.public_dns_zone}"
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_private_dns_zone" "private_zone" {
  name                = "${terraform.workspace}.${var.public_dns_zone}.private"
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "example" {
  name                  = "test"
  resource_group_name   = azurerm_resource_group.this.name
  private_dns_zone_name = azurerm_private_dns_zone.private_zone.name
  virtual_network_id    = azurerm_virtual_network.this.id

  tags = var.tags
}

resource "azurerm_role_assignment" "example" {
  scope                = azurerm_private_dns_zone.private_zone.id
  role_definition_name = "Private DNS Zone Contributor"
  principal_id         = azurerm_user_assigned_identity.aks.principal_id
}

