resource "azurerm_log_analytics_workspace" "this" {
  name                = "${var.name}-log"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.tags
}

resource "azurerm_container_app_environment" "this" {
  name                       = "${var.name}-app-env"
  location                   = var.location
  resource_group_name        = var.resource_group_name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.this.id
  infrastructure_subnet_id   = var.subnet_id

  tags = var.tags
}

resource "azurerm_container_app" "this" {
  name                         = "${var.name}-container"
  container_app_environment_id = azurerm_container_app_environment.this.id
  resource_group_name          = var.resource_group_name
  revision_mode                = "Single"

  template {
    container {
      name    = "kubectl"
      image   = "bitnami/kubectl:1.27-debian-11"
      cpu     = 1
      memory  = "2Gi"
      command = ["echo Hi"]
    }
  }

  tags = var.tags
}
