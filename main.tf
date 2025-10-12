terraform {
  backend "azurerm" {
    resource_group_name  = "test5TF"
    storage_account_name = "mazentfstate2"
    container_name       = "tfstate1"
    key                  = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}

  subscription_id = var.subscription_id
}

resource "azurerm_resource_group" "rg1" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "mazen_vnet1" {
    resource_group_name = var.resource_group_name
    name = var.vnet_name
    location = var.location
    address_space = ["10.0.0.0/16"]
      subnet {
    name             = "subnet1"
    address_prefixes = ["10.0.1.0/24"]
  }

  
}

resource "azurerm_log_analytics_workspace" "example1" {
  name                = "acctest-011"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

resource "azurerm_container_app_environment" "example1" {
  name                       = "Example-Environment1"
  location                   = azurerm_resource_group.rg1.location
  resource_group_name        = azurerm_resource_group.rg1.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example1.id
}

resource "azurerm_container_app" "example" {
  name                         = "example-app"
  container_app_environment_id = azurerm_container_app_environment.example1.id
  resource_group_name          = azurerm_resource_group.rg1.name
  revision_mode                = "Single"

  identity {
    type = "SystemAssigned"
  }

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mazenregistry.azurecr.io/nginx:${var.container_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}

data "azurerm_container_registry" "acr" {
  name                = "mazenregistry"
  resource_group_name = "test5TF"
}

resource "azurerm_role_assignment" "acr_pull" {
  depends_on = [azurerm_container_app.example]

  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_container_app.example.identity.0.principal_id


}

