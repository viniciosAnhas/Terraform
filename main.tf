terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.100.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

#Criacao do grupo de recurso 
resource "azurerm_resource_group" "rg_vinicios" {
  name     = "rg-vinicios"
  location = "brazilsouth"
}

# Criação da rede
resource "azurerm_virtual_network" "nt_vinicios" {
  name                = "nt-vinicios"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg_vinicios.location
  resource_group_name = azurerm_resource_group.rg_vinicios.name
}

# Criação da sub-rede
resource "azurerm_subnet" "sb_vinicios" {
  name                 = "sb-vinicios"
  resource_group_name  = azurerm_resource_group.rg_vinicios.name
  virtual_network_name = azurerm_virtual_network.nt_vinicios.name
  address_prefixes     = ["10.0.2.0/24"]
}

# Criação do IP público
resource "azurerm_public_ip" "public_ip_vinicios" {
  name                = "public-ip-vinicios"
  location            = azurerm_resource_group.rg_vinicios.location
  resource_group_name = azurerm_resource_group.rg_vinicios.name
  allocation_method   = "Static"

  tags = {
    environment = "production"
  }
}

# Criação da interface de rede com IP público
resource "azurerm_network_interface" "int_vinicios" {
  name                = "int-vinicios"
  location            = azurerm_resource_group.rg_vinicios.location
  resource_group_name = azurerm_resource_group.rg_vinicios.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.sb_vinicios.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.public_ip_vinicios.id
  }
}

# Criação da VM Windows
resource "azurerm_windows_virtual_machine" "vm_windows" {
  name                = "vm-windows"
  resource_group_name = azurerm_resource_group.rg_vinicios.name
  location            = azurerm_resource_group.rg_vinicios.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  admin_password      = "P@$$w0rd1234!"
  network_interface_ids = [
    azurerm_network_interface.int_vinicios.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    # storage_account_type = "Standard_LRS"
    storage_account_type = "Premium_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
