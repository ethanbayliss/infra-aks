output "cluster_private_fqdn" {
  value = azurerm_kubernetes_cluster.this.private_fqdn
}

output "cluster_private_ip" {
  value = azurerm_private_endpoint.kubernetes_api.private_service_connection.private_ip_address
}

output "cluster_kube_config" {
  value     = azurerm_kubernetes_cluster.this.kube_config
  sensitive = true
}

output "cluster_kube_config_raw" {
  value     = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}
