terraform {
  backend "azurerm" {
    resource_group_name  = "github"
    storage_account_name = "mazentfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

/*resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}
*/
resource "azurerm_virtual_network" "mazen_vnet" {
    resource_group_name = var.resource_group_name
    name = var.vnet_name
    location = var.location
    address_space = ["10.0.0.1/16"]
      subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  
}