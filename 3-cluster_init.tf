# module "cluster_init" {
#   source = "./modules/cluster_init"

#   resource_group_name = azurerm_resource_group.this.name
#   location            = azurerm_resource_group.this.location
#   subnet_id           = azurerm_subnet.private.id

#   input_manifests = ["olleh"]

#   tags = var.tags
# }
