resource "azurerm_private_dns_zone" "cluster" {
  name                = var.cluster_domain_name
  resource_group_name = azurerm_resource_group.this.name

  tags = var.tags
}
