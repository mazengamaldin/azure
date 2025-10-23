/*
Dynamic metric alerts
Could be used for the below alerts
-HttpResponseTime greater or less than dynamic threshold
-HttpResponseTime > dynamic threshold
-Capacity greater or less than dynamic threshold
metric name (HttpResponseTime)
Operator change between ( GreaterOrLessThan, GreaterThan)
*/



resource "azurerm_monitor_metric_alert" "dynamic_metric_alert" {
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
  

  dynamic_criteria {
    metric_namespace       = var.metric_namespace
    metric_name            = var.metric_name
    aggregation            = var.aggregation
    operator               = var.operator
    alert_sensitivity      = var.alert_sensitivity

    evaluation_total_count  = var.evaluation_total_count
    evaluation_failure_count= var.evaluation_failure_count

    # Only set if provided
    ignore_data_before      = length(var.ignore_data_before) > 0 ? var.ignore_data_before : null
    skip_metric_validation  = var.skip_metric_validation
  }
}