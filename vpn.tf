data "curl" "ssh_keys" {
  http_method = "GET"
  uri         = "https://github.com/ethanbayliss.keys"
}

resource "azurerm_virtual_machine" "vpn" {
  name                = openvpn
  resource_group_name = azurerm_resource_group.this
  location            = azurerm_resource_group.this.location

  network_interface_ids = []

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = data.curl.ssh_keys
    }
  }
}
