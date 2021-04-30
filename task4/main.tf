provider "azurerm" {
  features{}
}

resource "azurerm_resource_group" "rg" {
  
  name = "rg-${local.varcombination[0]}"
  location = "westus"

}
