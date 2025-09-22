terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.100.0"
    }
  }
}

provider "azurerm" {
  features {}
}

# Criação do Grupo de Recusro
resource "azurerm_resource_group" "rg-" {
  name     = var.rg-name
  location = var.rg-location
}

# Criação do AKS
resource "azurerm_kubernetes_cluster" "aks-" {
  name                = var.aks-name
  location            = azurerm_resource_group.rg-.location
  resource_group_name = azurerm_resource_group.rg-.name
  dns_prefix          = var.aks-dns_prefix
  kubernetes_version  = ""

  default_node_pool {
    name       = var.aks-pool-name
    node_count = 2
    vm_size    = var.aks-pool-vm_size
  }

  identity {
    type = "SystemAssigned"
  }
}

# Criação do ACR
resource "azurerm_container_registry" "acr-" {
  name                = var.acr-name
  resource_group_name = azurerm_resource_group.rg-.name
  location            = azurerm_resource_group.rg-.location
  sku                 = var.acr-sku
  admin_enabled       = false
}

# Criação do Regra para o ACR
resource "azurerm_role_assignment" "acr-role" {
  scope                            = azurerm_container_registry.acr-.id
  role_definition_name             = var.acr-role_definition_name
  principal_id                     = azurerm_kubernetes_cluster.aks-.kubelet_identity[0].object_id
  skip_service_principal_aad_check = true
}