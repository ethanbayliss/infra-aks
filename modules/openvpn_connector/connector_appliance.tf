resource "azurerm_linux_virtual_machine" "vpn" {
  name                = "${terraform.workspace}-vpn"
  resource_group_name = var.resource_group_name
  location            = var.az_location
  size                = "Standard_B1s"
  user_data           = base64encode(templatefile("${path.module}/src/vpn_userdata.sh.tpl",{
    TOKEN = "abc"
  }))

  network_interface_ids = [
    azurerm_network_interface.vpn_public.id,
    azurerm_network_interface.vpn_private.id,
  ]

  dynamic "source_image_reference" {
    for_each = var.source_image_reference[*]
    content {
      publisher = source_image_reference.value.publisher
      offer     = source_image_reference.value.offer
      sku       = source_image_reference.value.sku
      version   = source_image_reference.value.version
    }
  }

  admin_username = "vpn"
  admin_ssh_key {
    username   = "vpn"
    public_key = var.ssh_admin_rsa_public_key
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  tags = var.tags
}

resource "azurerm_network_interface" "vpn_public" {
  name                = "${terraform.workspace}-vpn-public-nic"
  resource_group_name = var.resource_group_name
  location            = var.az_location

  ip_configuration {
    name                          = "public"
    subnet_id                     = var.public_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.vpn.id
  }

  tags = var.tags
}

resource "azurerm_public_ip" "vpn" {
  name                = "${terraform.workspace}-vpn-ip"
  resource_group_name = var.resource_group_name
  location            = var.az_location
  allocation_method   = "Static"

  tags = var.tags
}

resource "azurerm_network_security_group" "vpn_public_sg" {
  name                = "${terraform.workspace}-vpn-public-sg"
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

resource "azurerm_network_interface_security_group_association" "vpn_public_sg" {
  network_interface_id      = azurerm_network_interface.vpn_public.id
  network_security_group_id = azurerm_network_security_group.vpn_public_sg.id
}

resource "azurerm_network_interface" "vpn_private" {
  name                = "${terraform.workspace}-vpn-private-nic"
  resource_group_name = var.resource_group_name
  location            = var.az_location

  # important for vpn usage
  enable_ip_forwarding = true

  ip_configuration {
    name                          = "private"
    subnet_id                     = var.private_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags
}
