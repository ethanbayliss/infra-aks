resource "azurerm_dns_zone" "public_zone" {
  name                = "${var.cluster_name}.${var.public_dns_zone}"
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}
