variable "name" {
  type        = string
  description = "Alert rule name"
}

variable "resource_group_name" {
  type        = string
  description = "Resource group name"
}

variable "location" {
  type        = string
  description = "Location of the alert resource"
}

variable "action_group_ids" {
  type        = set(string)
  description = "List of action group IDs"
}

variable "data_source_id" {
  type        = string
  description = "Resource ID of Application Insights or Log Analytics workspace"
}

variable "description" {
  type        = string
  default     = ""
}

variable "enabled" {
  type        = bool
  default     = true
}

variable "query" {
  type        = string
  description = "Kusto Query Language (KQL) query to run"
}

variable "severity" {
  type        = number
  default     = 2
}

variable "frequency" {
  type        = number
  default     = 5
  description = "How often the query runs (in minutes)"
}

variable "time_window" {
  type        = number
  default     = 30
  description = "Time range the query covers (in minutes)"
}

variable "trigger_operator" {
  type        = string
  description = "Operator for alert trigger (e.g., GreaterThan)"
}

variable "trigger_threshold" {
  type        = number
  description = "Threshold value for alert trigger"
}