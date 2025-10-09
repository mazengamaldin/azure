provider "azurerm" {
  features {}

  client_id       = "a90a80fd-88c4-4ea6-a12d-335dbe36e93e"
  client_secret   = "Lwa8Q~vuRl6Zf7AnAZejv-d9wM2L3dSKmua64dw0"
  subscription_id = "f37ac0f7-354f-40be-8f3e-2e004312dceb"
  tenant_id       = "fcdb8d1d-d931-48bc-82ba-e87fac48869b"
}

resource "azurerm_resource_group" "rg" {
  name     = "rg-terraform-vnet"
  location = "East US"
}

resource "azurerm_virtual_network" "vnet" {
  name                = "terraform-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}