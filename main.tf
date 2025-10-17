terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  required_version = ">= 1.0.0"
  backend "azurerm" {
    resource_group_name  = "backendrg"
    storage_account_name = "mazenbackendsa"
    container_name       = "backendcont"
    key                  = "terraform.tfstate"
  }
}


# Resource Group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location
}

# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "law" {
  name                = "example-law"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Container Registry
resource "azurerm_container_registry" "acr" {
  name                = "mazenregistry"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Basic"
  admin_enabled       = false
}

# User Assigned Managed Identity
resource "azurerm_user_assigned_identity" "acr_pull_identity" {
  name                = "acr-pull-identity"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
}

# Assign AcrPull role to the managed identity on ACR
resource "azurerm_role_assignment" "acr_pull_role" {
  scope                = azurerm_container_registry.acr.id
  role_definition_name = "AcrPull"
  principal_id         = azurerm_user_assigned_identity.acr_pull_identity.principal_id
}

# Container Apps Environment
resource "azurerm_container_app_environment" "env" {
  name                      = "example-env"
  location                  = azurerm_resource_group.rg.location
  resource_group_name       = azurerm_resource_group.rg.name
  log_analytics_workspace_id = azurerm_log_analytics_workspace.law.id
}

# Container App
resource "azurerm_container_app" "app" {
  name                         = "example-app"
  resource_group_name          = azurerm_resource_group.rg.name
  container_app_environment_id = azurerm_container_app_environment.env.id

  revision_mode = "Single"

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acr_pull_identity.id]
  }

  registry {
    server   = azurerm_container_registry.acr.login_server
    identity = azurerm_user_assigned_identity.acr_pull_identity.id
  }

  template {
    container {
      name   = "examplecontainer"
      image  = "nginx:latest"
      cpu    = 0.25
      memory = "0.5Gi"
    }
  }
}

# App Service Plan for Linux Web App
/*resource "azurerm_app_service_plan" "asp" {
  name                = "asp-test5tf"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true

  sku {
    tier = "Basic"
    size = "B1"
  }
}
*/

data "azurerm_app_service_plan" "existing_asp" {
  name                = "ASP-test5TF-b991"
  resource_group_name = "test5TF"
}



# Linux Web App
resource "azurerm_linux_web_app" "webapp" {
  name                = "testival"
  location            = "Central US"
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id = data.azurerm_app_service_plan.existing_asp.id

  identity {
    type         = "UserAssigned"
    identity_ids = [azurerm_user_assigned_identity.acr_pull_identity.id]
  }

  site_config {
    linux_fx_version = "DOCKER|${azurerm_container_registry.acr.login_server}/example-app:latest"
    # Do not set scm_type or port here
  }
  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE" = "false"
    "DOCKER_REGISTRY_SERVER_URL"           = "https://${azurerm_container_registry.acr.login_server}"
    "SCM_BASIC_AUTH_ENABLED"                = "true"
    "WEBSITES_PORT"                        = "80"
  }

}
/*
# Optional: ACR webhook to trigger deployment on image push
resource "azurerm_container_registry_webhook" "webhook" {
  name                = "webapp-deploy-webhook"
  resource_group_name = azurerm_resource_group.rg.name
  registry_name       = azurerm_container_registry.acr.name
  location            = azurerm_resource_group.rg.location
  service_uri         = "<deployment-center-webhook-url>"  # Replace with actual webhook URL after deployment
  actions             = ["push"]
  status              = "enabled"
}

*/