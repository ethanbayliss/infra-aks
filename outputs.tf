output "cluster_fqdn" {
  value = azurerm_kubernetes_cluster.this.fqdn
}

output "cluster_private_fqdn" {
  value = azurerm_kubernetes_cluster.this.private_fqdn
}

output "cluster_kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config
}

output "cluster_kube_config_raw" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw
}
