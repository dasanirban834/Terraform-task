resource "azurerm_virtual_network" "demo_network" {
  name                = "VNET"
  address_space       = var.vnet_address
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}

resource "azurerm_subnet" "demo_subnet" {
  name                 = "subnet"
  address_prefixes     = var.vnet_subnet_address
  virtual_network_name = azurerm_virtual_network.demo_network.name
  resource_group_name  = azurerm_resource_group.demo.name
}
