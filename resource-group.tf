resource "azurerm_resource_group" "default" {
  name     = "${terraform.workspace}-rg"
  location = "Australia East"

  tags = var.tags
}
