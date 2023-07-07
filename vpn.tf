data "curl" "ssh_keys" {
  http_method = "GET"
  uri         = "https://github.com/ethanbayliss.keys"
}

resource "azurerm_virtual_machine" "vpn" {
  name                = "openvpn"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  vm_size             = "Standard_A1_v2"

  network_interface_ids = []

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "20.04-LTS"
    version   = "latest"
  }

  os_profile {
    computer_name  = "openvpn"
    admin_username = "openvpn"
  }

  storage_os_disk {
    name          = "os"
    create_option = "FromImage"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = data.curl.ssh_keys.response
      path     = "/home/openvpn/.ssh/authorized_keys"
    }
  }
}
