# infra-aks
Playground for aks cluster with Terraform

## Features
- AKS Cluster spun up
- Private Cluster with VNet Endpoint in Terraform defined vnet
- OpenVPN CloudConnexa via VM connector
- Customizable address space
- DNS to cluster is working while on VPN

## In-progress
- Running kubectl against private cluster endpoint to do initialization
- ArgoCD installation

## Todo
- Azure AD workload identity with Azure Kubernetes Service (AKS) https://learn.microsoft.com/en-us/azure/aks/workload-identity-overview
- Autoscaling
- Secrets manager?
- auto-update node pool
- documentation, c4 diagram

# Usage
1. 
