terraform {
  required_version = ">= 1.6.0"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm",
      version = "4.58.0"
    }

    azapi = {
      source  = "azure/azapi",
      version = "2.8.0"
    }
  }
}

provider "azurerm" {
  features {}
}

provider "azapi" {
}
