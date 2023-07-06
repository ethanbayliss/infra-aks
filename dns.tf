resource "azurerm_dns_zone" "cluster" {
  name                = var.cluster_domain_name
  resource_group_name = azurerm_resource_group.this

  tags = var.tags
}
