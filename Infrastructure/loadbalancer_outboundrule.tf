
resource "azurerm_lb_backend_address_pool" "outbound_pool" {
  resource_group_name = azurerm_resource_group.demo.name
  loadbalancer_id     = azurerm_lb.demo_lb.id
  name                = "OutboundBackendPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "outbound_association" {
  count                   = 3
  network_interface_id    = element(azurerm_network_interface.demo_inc.*.id, count.index)
  backend_address_pool_id = azurerm_lb_backend_address_pool.outbound_pool.id
  ip_configuration_name   = "ipconfig1-${count.index}"
}

resource "azurerm_lb_outbound_rule" "outbound_rule" {
  resource_group_name      = azurerm_resource_group.demo.name
  loadbalancer_id          = azurerm_lb.demo_lb.id
  name                     = "OutboundRule"
  protocol                 = "Tcp"
  backend_address_pool_id  = azurerm_lb_backend_address_pool.outbound_pool.id
  enable_tcp_reset         = true
  idle_timeout_in_minutes  = 15
  allocated_outbound_ports = 10000

  frontend_ip_configuration {
    name = azurerm_public_ip.demo_ip.name
  }

}
