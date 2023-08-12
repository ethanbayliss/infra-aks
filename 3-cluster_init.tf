module "cluster_init" {
  source = "./modules/cluster_init"
  name   = "${var.cluster_name}-kubernetes-init"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private.id

  input_manifests    = ["olleh"]
  kubernetes_version = var.kubernetes_version

  tags = var.tags
}
