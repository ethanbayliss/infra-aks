output "cluster_endpoint" {
  description = "This cluster endpoint should be accessible over the VPN"
  value = azurerm_dns_a_record.kubernetes_api.fqdn
}
