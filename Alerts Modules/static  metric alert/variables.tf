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
  description = "List of action group IDs"
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
  description = "Operator (GreaterThan, LessThan, etc.)"
}

variable "threshold" {
  type        = number
  description = "Threshold value"
}