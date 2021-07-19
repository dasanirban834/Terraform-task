locals {
  nsgrules = {

    HTTP = {
      name                       = "HTTP"
      priority                   = 101
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = "80"
      source_address_prefix      = "Internet"
      destination_address_prefix = "*"

    }

  }
}

resource "azurerm_network_security_group" "demo_nsg" {
  name                = "NSG"
  resource_group_name = azurerm_resource_group.demo.name
  location            = azurerm_resource_group.demo.location
}

resource "azurerm_network_security_rule" "demo_nsg_rule" {
  for_each                    = local.nsgrules
  name                        = each.key
  priority                    = each.value.priority
  direction                   = each.value.direction
  access                      = each.value.access
  protocol                    = each.value.protocol
  source_port_range           = each.value.source_port_range
  destination_port_range      = each.value.destination_port_range
  source_address_prefix       = each.value.source_address_prefix
  destination_address_prefix  = each.value.destination_address_prefix
  resource_group_name         = azurerm_resource_group.demo.name
  network_security_group_name = azurerm_network_security_group.demo_nsg.name
}


resource "azurerm_network_interface_security_group_association" "demo_association" {
  count                     = 3
  network_interface_id      = element(azurerm_network_interface.demo_inc.*.id, count.index)
  network_security_group_id = azurerm_network_security_group.demo_nsg.id
}