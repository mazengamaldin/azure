/*
Static metric alerts
Could be used for below alerts
-Http4xx > 1
-Http5xx > 1 (could not be found on console)
-HttpResponseTime < 0.04 (change metric name to "HttpResponseTime" or Http4xx or Http5xx)
-CpuPercentage >= 90
-=MemoryPercentage > 80

Note: http5xx could not be found in console
*/



resource "azurerm_monitor_metric_alert" "static_metric_alert" {
  name                = var.name
  resource_group_name = var.resource_group_name
  scopes              = var.scopes
  description         = var.description
  severity            = var.severity
  frequency           = var.frequency
  window_size         = var.window_size

 action {
     action_group_id = var.action_group_ids
 }

    
  

  criteria {
    metric_namespace = var.metric_namespace
    metric_name      = var.metric_name
    aggregation      = var.aggregation
    operator         = var.operator
    threshold        = var.threshold
  }
}