terraform {
  backend "azurerm" {
    resource_group_name  = "test5TF"
    storage_account_name = "mazentfstate"
    container_name       = "tfstate"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "mazen_vnet" {
    resource_group_name = var.resource_group_name
    name = var.vnet_name
    location = var.location
    address_space = ["10.0.0.0/16"]
      subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  
}


resource "azurerm_log_analytics_workspace" "example" {
  name                = "acctest-01"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "example" {
  name                       = "Example-Environment"
  location                   = azurerm_resource_group.rg.location
  resource_group_name        = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id
}

resource "azurerm_container_app" "example" {
  name                         = "example-app"
  container_app_environment_id = azurerm_container_app_environment.example.id
  resource_group_name          = azurerm_resource_group.rg.name
  revision_mode                = "Single"

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mazenregistry.azurecr.io/nginx:${var.container_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}