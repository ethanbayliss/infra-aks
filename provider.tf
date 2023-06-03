variable "client_secret" {
}

variable "client_id" {
}

variable "tenant_id" {
}

variable "subscription_id" {
}

variable "tags" {
  default = {
    iac  = "terraform"
    iac_repo = "https://github.com/ethanbayliss/infra-aks"
    environment = "sandbox"
  }
}

# We strongly recommend using the required_providers block to set the
# Azure Provider source and version being used
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.59"
    }
  }
  cloud {
    organization = "ethanbayliss"

    workspaces {
      name = "infra-aks"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}

  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
  subscription_id = var.subscription_id
}
