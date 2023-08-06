resource "azurerm_resource_group" "this" {
  name     = "${terraform.workspace}-rg"
  location = var.location

  tags = var.tags
}
