#App service
#****************************************************************************





# HttpResponseTime greater or less than dynamic threshold
# HttpResponseTime > dynamic threshold
# ------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "dynamic_threshold_alert" {

  name                = "Admin-KB-App-Prod-Dynamic-ResponseTime-Alert"
  resource_group_name = "your-resource-group"  
  scopes              = [azurerm_app_service.admin_kb_app_prod.id]  #set of strings
  description         = "Alert when HttpResponseTime breaches dynamic threshold"
  severity            = 2
  frequency           = "PT1M"  
  window_size         = "PT5M"  

#Action group to notify or automate response
  action {
     action_group_id = azurerm_monitor_action_group.example.id
   }

  dynamic_criteria {
    metric_namespace       = "Microsoft.Web/sites"
    metric_name            = "HttpResponseTime"
    aggregation            = "Average"
    operator               = "GreaterOrLessThan"
    alert_sensitivity      = "Medium"  # Can be Low, Medium, or High

    # Optional parameters:
    #evaluation_total_count = 4
    #evaluation_failure_count = 4
    # ignore_data_before    = "2024-01-01T00:00:00Z" 
    # skip_metric_validation = false
}



}


#Http4xx > 1
#Http5xx > 1 (could not be found on console)
#----------------------------------------------------------------------
resource "azurerm_monitor_metric_alert" "http4xx_alert" {
  name                = "Admin-KB-App-Prod-Http4xx-Alert"
  resource_group_name = "your-resource-group"  
  scopes              = [azurerm_app_service.admin_kb_app_prod.id]  #Set of string
  description         = "Alert when Http4xx errors are greater than 1"
  severity            = 2
  frequency           = "PT1M"  # Evaluate every 1 minute
  window_size         = "PT5M"  # Over last 5 minutes

  criteria {
    metric_namespace = "Microsoft.Web/sites"
    metric_name      = "Http4xx"
    aggregation      = "Total"
    operator         = "GreaterThan"
    threshold        = 1
  }

#Action group to notify or automate response

  action {
    action_group_id = azurerm_monitor_action_group.example.id
  }
}




#Unwrap throw errors found in the log ****not for app service***
#------------------------------------------------------------
resource "azurerm_monitor_scheduled_query_rules_alert" "example" {
  name                = "example"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  action {
action_group = azurerm_monitor_action_group.example.id     #List of action group reference resource IDs
  }
  data_source_id = azurerm_application_insights.example.id #app insights or analytics workspace id
  description    = "Alert when total results cross threshold"
  enabled        = true

  # Count all requests with server error result code grouped into 5-minute bins
  query       = <<-QUERY
  requests
    | where tolong(resultCode) >= 500
    | summarize count() by bin(timestamp, 5m)
  QUERY
  severity    = 1
  frequency   = 5
  time_window = 30

  trigger {
    operator  = "GreaterThan"
    threshold = 100
  }


}