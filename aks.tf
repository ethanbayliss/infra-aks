resource "azurerm_kubernetes_cluster" "this" {
  name                = "${terraform.workspace}-aks"
  location            = azurerm_resource_group.default.location
  resource_group_name = azurerm_resource_group.default.name
  dns_prefix          = "${terraform.workspace}-k8s"

  default_node_pool {
    name            = "burstable"
    node_count      = 2
    vm_size         = "Standard_B4ms"
    os_disk_size_gb = 60
  }

  service_principal {
    client_id     = var.client_id
    client_secret = var.client_secret
  }

  role_based_access_control_enabled = true

  tags = var.tags
}
