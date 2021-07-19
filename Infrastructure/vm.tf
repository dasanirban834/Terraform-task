
resource "azurerm_network_interface" "demo_inc" {
  count               = 3
  name                = "nic-${count.index}"
  location            = azurerm_resource_group.demo.location
  resource_group_name = azurerm_resource_group.demo.name

  ip_configuration {
    name                          = "ipconfig1-${count.index}"
    subnet_id                     = azurerm_subnet.demo_subnet.id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.tags

}

resource "azurerm_linux_virtual_machine" "demo_linux" {
  count                           = 3
  name                            = "vm-${count.index}"
  resource_group_name             = azurerm_resource_group.demo.name
  location                        = azurerm_resource_group.demo.location
  zone                            = element(var.availability_zones, count.index)
  size                            = "Standard_F2"
  admin_username                  = "azureuser"
  network_interface_ids = [
    element(azurerm_network_interface.demo_inc.*.id, count.index),
  ]
  disable_password_authentication = true

  admin_ssh_key {
    username = "azureuser"
    public_key = file("../private.pub")  # key-generation: ssh-keygen -m PEM -t rsa -b 4096
  }
  
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"

  }

    provisioner "remote-exec" {
    inline = [
      "sudo apt update -y",
      "sudo apt install apache2 -y",
      "sudo systemctl start apache2",
      "sudo systemctl enable apache2",
      "echo <p>This is VM-${count.index}</p> >> /var/www/html/index.html",
      "sudo systemctl reload apache2"
    ]
    on_failure = continue
  }

  connection {
    type = "ssh"
    user = "azureuser"
    private_key = file("../private")
    host = element(self.*.public_ip_address, count.index)
  }

  tags = var.tags

}