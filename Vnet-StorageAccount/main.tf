terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=2.26"
    }
  }
  required_version = ">= 0.14.9"
}

#configure provider
provider "azurerm" {
  features {}
}


resource "azurerm_resource_group" "example" {
  name     = "RG02"
  location = "West Europe"
}
resource "azurerm_virtual_network" "vnet612" {
  name                = "example-network"
  address_space       = ["10.0.0.0/24"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}
resource "azurerm_storage_account" "example" {
  name                     = "storageaccount098prv"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "GRS"
  tags = {
    environment = "staging"
  }
}