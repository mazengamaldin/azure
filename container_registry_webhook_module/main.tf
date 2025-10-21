resource "azurerm_container_registry_webhook" "webhook" {
  name                = var.name
  resource_group_name = var.resource_group_name
  registry_name       = var.registry_name
  location            = var.location
  service_uri         = var.service_uri
  actions             = var.actions
  status              = var.status
}