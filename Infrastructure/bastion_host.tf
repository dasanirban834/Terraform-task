resource "azurerm_subnet" "bastion_subnet" {
  name                 = "AzureBastionSubnet"
  resource_group_name  = azurerm_resource_group.demo.name
  virtual_network_name = azurerm_virtual_network.demo_network.name
  address_prefixes     = ["10.0.5.0/27"]
}

resource "azurerm_public_ip" "bastion_ip" {
  name                = "BastionPublicIP"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = "BastionHost"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                 = "configuration"
    subnet_id            = azurerm_subnet.bastion_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_ip.id
  }

}