provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "example-rg"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "example-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}
