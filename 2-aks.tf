resource "azurerm_kubernetes_cluster" "this" {
  name                = "${terraform.workspace}"
  sku_tier            = var.cluster_sku_tier
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dns_prefix_private_cluster = "cluster"
  private_dns_zone_id        = azurerm_private_dns_zone.private_zone.id
  private_cluster_enabled    = true

  kubernetes_version = var.kubernetes_version

  default_node_pool {
    name            = var.default_node_pool.name
    node_count      = var.default_node_pool.node_count
    vm_size         = var.default_node_pool.vm_size
    os_disk_size_gb = var.default_node_pool.os_disk_size_gb
  }

  identity {
    type = "SystemAssigned" 
  }
  workload_identity_enabled = true
  oidc_issuer_enabled       = true

  role_based_access_control_enabled = true

  tags = var.tags
}

# expose the kubernetes api to the private subnet
resource "azurerm_private_endpoint" "kubernetes_api" {
  name                = "${terraform.workspace}-kubernetes_api"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "${terraform.workspace}-kubernetes-api-privateserviceconnection"
    private_connection_resource_id = azurerm_kubernetes_cluster.this.id
    is_manual_connection           = false
    # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
    subresource_names              = ["management"]
  }

  tags = var.tags
}
