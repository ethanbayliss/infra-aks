resource "azurerm_resource_group" "default" {
  name     = "${terraform.workspace}-rg"
  location = var.location

  tags = var.tags
}
