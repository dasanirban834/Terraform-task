provider "azurerm" {
    features{}
}

resource "random_password" "password" {
    length = 16
    special = true
    override_special = "_%@"
}

locals {

    var =random_password.password.result

}

resource "azurerm_resource_group" "RG_01" {
    name = "Terraform-Lab"
    location = "westeurope"
}


resource "azurerm_virtual_network" "main" {
    name = "vnet021"
    address_space = ["10.0.0.0/18"]
    location = azurerm_resource_group.RG_01.location
    resource_group_name = azurerm_resource_group.RG_01.name
}

resource "azurerm_subnet" "subnet021" {
    name = "subnet021"
    address_prefixes = ["10.0.0.0/24"]
    virtual_network_name = azurerm_virtual_network.main.name
    resource_group_name = azurerm_resource_group.RG_01.name
}

resource "azurerm_public_ip" "windows_ip" {
  name = "windows-ip"
  resource_group_name = azurerm_resource_group.RG_01.name
  location = azurerm_resource_group.RG_01.location
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "example" {
    name = "example-nic"
    location = azurerm_resource_group.RG_01.location
    resource_group_name = azurerm_resource_group.RG_01.name

    ip_configuration {
        name = "internal"
        subnet_id = azurerm_subnet.subnet021.id
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id = azurerm_public_ip.windows_ip.id
    }
}

resource "azurerm_windows_virtual_machine" "windows_vm" {
    name = "windows_vm"
    resource_group_name = azurerm_resource_group.RG_01.name
    location = azurerm_resource_group.RG_01.location
    computer_name  = "hostname"
    admin_username = var.user
    admin_password = local.var
    size  = "Standard_DS1_v2"
    network_interface_ids = [azurerm_network_interface.example.id]

    os_disk {
        name = "myosdisk1"
        caching = "ReadWrite"
        storage_account_type = "Standard_LRS"
    }

    source_image_reference {
        publisher = "MicrosoftWindowsServer"
        offer = "WindowsServer"
        sku = "2016-Datacenter"
        version = "latest"
    }
}