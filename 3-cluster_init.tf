locals {
  admin_kubeconfig = replace(azurerm_kubernetes_cluster.this.kube_config_raw, azurerm_kubernetes_cluster.this.oidc_issuer_url, azurerm_dns_a_record.kubernetes_api.fqdn)
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

  tags = var.tags
}
