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

resource "azurerm_nat_gateway" "this" {
  name                = "${terraform.workspace}-nat"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku_name            = "Standard" # must match public IP sku
}

resource "azurerm_public_ip" "nat" {
  name                = "${terraform.workspace}-nat-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Dynamic"
  sku                 = "Standard" # must match NAT gateway sku
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "private_nat" {
  nat_gateway_id = azurerm_nat_gateway.this.id
  subnet_id      = azurerm_subnet.private.id
}
