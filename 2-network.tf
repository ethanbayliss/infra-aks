resource "azurerm_virtual_network" "this" {
  name                = "${var.cluster_name}-network"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  address_space = [var.address_space.parent_subnet]

  tags = var.tags
}

resource "azurerm_subnet" "private" {
  name                 = "${var.cluster_name}-private"
  resource_group_name  = azurerm_resource_group.this.name

  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.address_space.private_subnet]
}

resource "azurerm_subnet" "public" {
  name                 = "${var.cluster_name}-public"
  resource_group_name  = azurerm_resource_group.this.name

  virtual_network_name = azurerm_virtual_network.this.name
  address_prefixes     = [var.address_space.public_subnet]
}

resource "azurerm_nat_gateway" "this" {
  name                = "${var.cluster_name}-nat"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  sku_name            = "Standard" # must match public IP sku

  tags = var.tags
}

resource "azurerm_public_ip" "nat" {
  name                = "${var.cluster_name}-nat-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static" # must be static for Standard sku
  sku                 = "Standard" # must match NAT gateway sku

  tags = var.tags
}

resource "azurerm_nat_gateway_public_ip_association" "nat" {
  nat_gateway_id       = azurerm_nat_gateway.this.id
  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "private_nat" {
  nat_gateway_id = azurerm_nat_gateway.this.id
  subnet_id      = azurerm_subnet.private.id
}
