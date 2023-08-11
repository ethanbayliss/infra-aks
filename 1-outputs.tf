# output "cluster_endpoint" {
#   description = "This cluster endpoint should be accessible over the VPN"
#   value       = azurerm_dns_a_record.kubernetes_api.fqdn
# }

output "dns_config" {
  description = "Use these NS records to propagate DNS"
  value       = {
    domain     = local.public_dns_zone
    ns_records = azurerm_dns_zone.public_zone.name_servers
  }
}
