resource "azurerm_linux_virtual_machine_scale_set" "vpn-connector" {
  name                 = "${var.name}-vpn"
  resource_group_name  = var.resource_group_name
  location             = var.az_location
  computer_name_prefix = "vpn-connector"

  sku       = "Standard_B1s"
  instances = 1

  user_data = base64encode(templatefile("${path.module}/src/vpn_userdata.sh.tpl",{
    TOKEN = var.openvpn_connector_token
  }))

  network_interface {
    name                 = "vpn-connector-private"
    enable_ip_forwarding = true
    ip_configuration {
      name      = "private"
      subnet_id = var.private_subnet.id
    }
  }

  network_interface {
    name                      = "vpn-connector-public"
    primary                   = true
    enable_ip_forwarding      = true
    network_security_group_id = azurerm_network_security_group.vpn_public_sg.id
    ip_configuration {
      name      = "public"
      primary   = true
      subnet_id = var.public_subnet.id
      public_ip_address  {
        name = "public"
      }
    }
  }

  dynamic "source_image_reference" {
    for_each = var.source_image_reference[*]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  admin_username                  = "vpn"
  disable_password_authentication = true
  admin_ssh_key {
    username   = "vpn"
    public_key = var.ssh_admin_rsa_public_key
  }

  tags = var.tags
}

resource "azurerm_network_security_group" "vpn_public_sg" {
  name                = "${var.name}-vpn-public"
  resource_group_name = var.resource_group_name
  location            = var.az_location

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.ssh_admin_ip
    destination_address_prefix = "*"
  }

  tags = var.tags
}
