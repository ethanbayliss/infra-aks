variable "ssh_rsa_key" {
  type = string
}

variable "admin_ip" {
  type = string
}

resource "azurerm_linux_virtual_machine" "vpn" {
  name                = "${terraform.workspace}-vpn"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  size                = "Standard_B1s"
  user_data           = base64encode(templatefile("${path.module}/src/vpn_userdata.sh",{
    PUBLIC_IP = azurerm_public_ip.vpn.ip_address,
    CLIENT    = "vpn"
  }))

  network_interface_ids = [
    azurerm_network_interface.vpn_public.id,
    azurerm_network_interface.vpn_private.id,
  ]

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  admin_username = "vpn"
  admin_ssh_key {
    username   = "vpn"
    public_key = var.ssh_rsa_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = var.tags
}

resource "azurerm_network_interface" "vpn_public" {
  name                = "${terraform.workspace}-vpn-public-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "public"
    subnet_id                     = azurerm_subnet.public.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vpn.id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "vpn" {
  name                = "${terraform.workspace}-vpn-ip"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  allocation_method   = "Static"

  tags = var.tags
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
  security_rule {
    name                       = "ovpn"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    source_port_range          = "*"
    destination_port_range     = "1194"
    source_address_prefix      = var.admin_ip
    destination_address_prefix = "*"
  }

  tags = var.tags
}

resource "azurerm_network_interface_security_group_association" "vpn_public_sg" {
  network_interface_id      = azurerm_network_interface.vpn_public.id
  network_security_group_id = azurerm_network_security_group.vpn_public_sg.id
}

resource "azurerm_network_interface" "vpn_private" {
  name                = "${terraform.workspace}-vpn-private-nic"
  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location

  ip_configuration {
    name                          = "private"
    subnet_id                     = azurerm_subnet.private.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}

output "vpn_public_ip" {
  value = azurerm_linux_virtual_machine.vpn.public_ip_addresses[0]
}
