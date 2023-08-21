locals {
  admin_kubeconfig = replace( #replace the endpoint provided in the default kubeconfig with the private endpoint's dns record we made
    jsonencode(yamldecode(azurerm_kubernetes_cluster.this.kube_config_raw)), 
    azurerm_kubernetes_cluster.this.private_fqdn, 
    azurerm_dns_a_record.kubernetes_api.fqdn
  )
}

module "cluster_init" {
  source = "./modules/cluster_init"
  name   = "${var.cluster_name}-kubernetes-init"

  resource_group_name = azurerm_resource_group.this.name
  location            = azurerm_resource_group.this.location
  subnet_id           = azurerm_subnet.private.id

  input_manifests    = ["olleh"]
  kubernetes_version = var.kubernetes_version
  kubernetes_config  = local.admin_kubeconfig

  depends_on = [ 
    azurerm_dns_a_record.kubernetes_api
  ]

  tags = var.tags
}
