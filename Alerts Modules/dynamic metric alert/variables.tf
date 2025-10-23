variable "name" {
  type        = string
  description = "Alert rule name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "scopes" {
  type        = list(string)
  description = "List of resource IDs to monitor"
}

variable "action_group_ids" {
  type        = string
  description = "Action group ID"
}

variable "description" {
  type        = string
  default     = ""
}

variable "severity" {
  type        = number
  default     = 2
}

variable "frequency" {
  type        = string
  default     = "PT1M"
  description = "Evaluation frequency (ISO 8601 duration)"
}

variable "window_size" {
  type        = string
  default     = "PT5M"
  description = "Evaluation window size (ISO 8601 duration)"
}

variable "metric_namespace" {
  type        = string
  description = "Metric namespace"
}

variable "metric_name" {
  type        = string
  description = "Metric name"
}

variable "aggregation" {
  type        = string
  description = "Aggregation type (Average, Total, etc.)"
}

variable "operator" {
  type        = string
  description = "Operator (GreaterThan, LessThan, GreaterOrLessThan)"
}

variable "alert_sensitivity" {
  type        = string
  description = "Alert sensitivity (Low, Medium, High)"
}

variable "evaluation_total_count" {
  type        = number
  default     = 4
  description = "Number of aggregated lookback points"
}

variable "evaluation_failure_count" {
  type        = number
  default     = 4
  description = "Number of violations to trigger alert"
}

variable "ignore_data_before" {
  type        = string
  default     = ""
  description = "ISO8601 date to start learning historical data"
}

variable "skip_metric_validation" {
  type        = bool
  default     = false
  description = "Skip metric validation for custom metrics"
}