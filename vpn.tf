locals {
  instance_name = "openvpn"
}

variable "ssh_rsa_key" {
  type = string
}
variable "admin_ip" {
  type = string
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
    name          = "${terraform.workspace}-${local.instance_name}-os"
    create_option = "FromImage"
  }
  delete_os_disk_on_termination = true

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      key_data = var.ssh_rsa_key
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
    public_ip_address_id          = azurerm_public_ip.vpn.id
  }
}

resource "azurerm_public_ip" "vpn" {
  name                = "${terraform.workspace}-vpn-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Dynamic"
}

resource "azurerm_network_security_group" "vpn_public_sg" {
  name                = "${terraform.workspace}-vpn-public-sg"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = var.admin_ip
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "vpn_public_sg" {
  network_interface_id      = azurerm_network_interface.vpn_public.id
  network_security_group_id = azurerm_network_security_group.vpn_public_sg.id
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
