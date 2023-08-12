resource "azurerm_virtual_network" "this" {
  name                = "${var.name}-network"
  location            = var.location
  resource_group_name = var.resource_group_name

  address_space = [var.address_space.parent_subnet]

  tags = var.tags
}

resource "azurerm_subnet" "private" {
  name                 = "${var.name}-private"
  resource_group_name = var.resource_group_name

  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.address_space.private_subnet]
}
