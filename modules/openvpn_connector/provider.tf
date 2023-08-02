terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.67"
    }
    openvpn-cloud = {
      source = "OpenVPN/openvpn-cloud"
      version = "0.0.11"
    }
  }
}
