terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.69"
    }
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
