terraform {
  required_version = "1.0.2"
  backend "azurerm" {
    resource_group_name  = "tstate"
    storage_account_name = "tstate25159"
    container_name       = "tstate"
    key                  = "terraform.tfstate"
  }

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.68.0"
    }


    random = {
      source  = "hashicorp/random"
      version = "3.1.0"
    }

  }

}

provider "azurerm" {
  features {}
}