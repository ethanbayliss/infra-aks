resource "azurerm_kubernetes_cluster" "this" {
  name                = "${var.cluster_name}"
  sku_tier            = var.cluster_sku_tier
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name

  dns_prefix              = "cluster"
  private_dns_zone_id     = "System"
  private_cluster_enabled = true

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
  name                = "${var.cluster_name}-kubernetes_api"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  subnet_id           = azurerm_subnet.private.id

  private_service_connection {
    name                           = "${var.cluster_name}-kubernetes-api-privateserviceconnection"
    private_connection_resource_id = azurerm_kubernetes_cluster.this.id
    is_manual_connection           = false
    # https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview#private-link-resource
    subresource_names              = ["management"]
  }

  tags = var.tags
}

resource "azurerm_dns_a_record" "kubernetes_api" {
  name                = "cluster"
  zone_name           = azurerm_dns_zone.public_zone.name
  resource_group_name = azurerm_resource_group.this.name

  ttl                 = 60
  records             = [azurerm_private_endpoint.kubernetes_api.private_service_connection[0].private_ip_address]
}
