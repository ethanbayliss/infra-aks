data "curl" "ssh_keys" {
  http_method = "GET"
  uri         = "https://github.com/ethanbayliss.keys"
}

locals {
  instance_name = "openvpn"
}

resource "azurerm_virtual_machine" "vpn" {
  name                = "${terraform.workspace}-${local.instance_name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  vm_size             = "Standard_A1_v2"

  network_interface_ids = [
    azurerm_network_interface.vpn_public.id,
    azurerm_network_interface.vpn_private.id,
  ]

  storage_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
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

resource "azurerm_network_interface" "vpn_public" {
  name                = "${terraform.workspace}-${local.instance_name}-public-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_network_interface" "vpn_private" {
  name                = "${terraform.workspace}-${local.instance_name}-private-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "default"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }
}
