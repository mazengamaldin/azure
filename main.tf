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
  name                = var.vnet_name
  location            = var.location
  address_space       = ["10.0.0.0/16"]

  subnet {
    name           = "subnet1"
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

data "azurerm_container_registry" "acr" {
  name                = "mazenregistry"
  resource_group_name  = "test5TF"
}

# Existing User Assigned Identity
resource "azurerm_user_assigned_identity" "acrpullidentity" {
  name                = "acr-pull-identity"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
}

resource "azurerm_role_assignment" "acr_pull" {
  scope                = data.azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acrpullidentity.principal_id
}

resource "azurerm_container_app_environment" "example1" {
  name                      = "Example-Environment1"
  location                  = azurerm_resource_group.rg1.location
  resource_group_name       = azurerm_resource_group.rg1.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example1.id
}

resource "azurerm_container_app" "example" {
  name                         = "example-app"
  container_app_environment_id = azurerm_container_app_environment.example1.id
  resource_group_name          = azurerm_resource_group.rg1.name
  revision_mode                = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acrpullidentity.id]
  }

  registry {
    server   = data.azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.acrpullidentity.id
  }

  template {
    container {
      name   = "examplecontainerapp"
      image  = "mazenregistry.azurecr.io/example-app:${var.container_image_tag}"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}

# New resources with unique names to avoid conflicts

resource "azurerm_user_assigned_identity" "acrpullidentity_new" {
  name                = "acr-pull-identity-new"
  resource_group_name = azurerm_resource_group.rg1.name
  location            = azurerm_resource_group.rg1.location
}

data "azurerm_app_service_plan" "existing_asp" {
  name                = "ASP-test5TF-ac8f"
  resource_group_name = "test5TF"
}

resource "azurerm_app_service" "webapp_new" {
  name                = "testorini-new"
  location            = azurerm_resource_group.rg1.location
  resource_group_name = azurerm_resource_group.rg1.name
  app_service_plan_id = data.azurerm_app_service_plan.existing_asp.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acrpullidentity_new.id]
  }

  site_config {
    linux_fx_version = "DOCKER|${data.azurerm_container_registry.acr.login_server}/example-app:latest"
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"          = "https://${data.azurerm_container_registry.acr.login_server}"
  }
}

resource "azurerm_role_assignment" "acr_pull_new" {
  principal_id         = azurerm_user_assigned_identity.acrpullidentity_new.principal_id
  role_definition_name = "AcrPull"
  scope                = data.azurerm_container_registry.acr.id
}

/*resource "azurerm_container_registry_webhook" "webhook_new" {
  name                = "webapp-deploy-webhook-new"
  resource_group_name = azurerm_resource_group.rg1.name
  registry_name       = data.azurerm_container_registry.acr.name
  location            = azurerm_resource_group.rg1.location
  service_uri         = "<deployment-center-webhook-url>"  # Replace with actual webhook URL
  actions             = ["push"]
  status              = "enabled"
}
*/
