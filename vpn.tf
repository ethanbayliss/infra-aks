locals {
  instance_name = "openvpn"
  ssh_rsa_key   = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDWNfRM+3wcvyCrKlFucwcs7ssij0mCauloprMu5evcVu+gyiG9kYggl9uq4d59O2q8ThJ1XBayhd//IGSLGO/Q8QwWjU0RM6ZLfM1IQmDkkYDTPvanIDJtCr4RqBu12qkOn+swIN1vy90h6jAHS6prDqkPFwuwbTPbzdyShNgmOlH1D6Q8Hlf8B1x0wUDjARNAork3D4V2OCMndQwYR7tEGdDwIjuH1qV+PZPhZ0Wcs7uNF4737FISY2gkgAYiw/n0ZaU9K3qm3bmDoK9/G7qoOOUeBQ/rJ4g56ytITxT8uvmQrIiIQyXcmw+7AR+MGSVWYWvg5B2MLQYX5e1aQbxCCnZuYQO874ajq051YhhvV6l3y0jWSXFdi21guKCFFf4C0W2UF2OJM2F1Qhuko7vUMjX4N48YD3XRXb190hmod9fH0/Kts+nmJX3YVgXuEo9AHdAAuFlyRZpAOzBneJ1nf4PSzk1ZO524P3LQ1NLfuVxafj0JPZGy8V1+NdSzq3U= ebayliss@DESKTOP-4NGKHUI"
}

resource "azurerm_virtual_machine" "vpn" {
  name                = "${terraform.workspace}-${local.instance_name}"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  vm_size             = "Standard_B1s"

  primary_network_interface_id = azurerm_network_interface.vpn_private.id
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
      key_data = local.ssh_rsa_key
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
