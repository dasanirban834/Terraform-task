resource "azurerm_public_ip" "demo_ip" {
  name                = "PublicIPForLB"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_lb" "demo_lb" {
  name                = "Load_Balancer-${random_id.demo_id.hex}"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                 = azurerm_public_ip.demo_ip.name
    public_ip_address_id = azurerm_public_ip.demo_ip.id

  }

}

resource "azurerm_lb_backend_address_pool" "demo_pool" {
  resource_group_name = azurerm_resource_group.demo.name
  loadbalancer_id     = azurerm_lb.demo_lb.id
  name                = "BackendPool"
}

resource "azurerm_network_interface_backend_address_pool_association" "demo_association" {
  count                   = 3
  network_interface_id    = element(azurerm_network_interface.demo_inc.*.id, count.index)
  ip_configuration_name   = "ipconfig1-${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.demo_pool.id
}

resource "azurerm_lb_rule" "demo_rule" {
  resource_group_name            = azurerm_resource_group.demo.name
  loadbalancer_id                = azurerm_lb.demo_lb.id
  name                           = "LBRule1"
  protocol                       = "Tcp"
  frontend_port                  = 80
  backend_port                   = 80
  frontend_ip_configuration_name = azurerm_public_ip.demo_ip.name
  backend_address_pool_id        = azurerm_lb_backend_address_pool.demo_pool.id
  probe_id                       = azurerm_lb_probe.demo_probe.id
  disable_outbound_snat          = true
  depends_on = [
    azurerm_lb_probe.demo_probe
  ]
  idle_timeout_in_minutes = 15
  enable_tcp_reset        = true
}

resource "azurerm_lb_probe" "demo_probe" {
  resource_group_name = azurerm_resource_group.demo.name
  loadbalancer_id     = azurerm_lb.demo_lb.id
  name                = "HealthProbe"
  protocol            = "Http"
  request_path        = "/"
  port                = 80
  interval_in_seconds = 15
  number_of_probes    = 2
}