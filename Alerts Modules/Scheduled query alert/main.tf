resource "azurerm_monitor_scheduled_query_rules_alert" "example" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  action {
action_group = var.action_group_ids   #List of action group reference resource IDs
  }
  data_source_id = var.data_source_id #app insights or analytics workspace id
  description    = var.description
  enabled        = var.enabled

 
  query       = var.query
  severity    = var.severity
  frequency   = var.frequency
  time_window = var.time_window

  trigger {
    operator  = var.trigger_operator
    threshold = var.trigger_threshold
  }


}