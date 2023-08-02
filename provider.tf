terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.67"
    }
    # openvpncloud = {
    #   source = "OpenVPN/openvpn-cloud"
    #   version = "0.0.11"
    # }
  }
  cloud {
    organization = "ethanbayliss"

    workspaces {
      name = "infra-aks"
    }
  }
}

variable "client_secret" {
}

variable "client_id" {
}

variable "tenant_id" {
}

variable "subscription_id" {
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}

variable "openvpn_base_url" {
}

variable "openvpn_client_id" {
}

variable "openvpn_client_secret" {
  sensitive = true
}

# provider "openvpncloud" {
#   base_url      = var.openvpn_base_url
#   client_id     = var.openvpn_client_id
#   client_secret = var.openvpn_client_secret
# }
