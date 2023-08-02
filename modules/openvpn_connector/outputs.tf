output "vpn_public_ip" {
  value = azurerm_linux_virtual_machine.vpn.public_ip_addresses[0]
}
