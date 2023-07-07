resource "azurerm_virtual_network" "this" {
  name                = "${terraform.workspace}-network"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  address_space = ["10.69.0.0/16"]
}

resource "azurerm_subnet" "private" {
  name                 = "${terraform.workspace}-private"
  resource_group_name  = azurerm_resource_group.this.name

  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.69.8.0/21"]
}

resource "azurerm_subnet" "public" {
  name                 = "${terraform.workspace}-public"
  resource_group_name  = azurerm_resource_group.this.name

  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = ["10.69.16.0/21"]
}
