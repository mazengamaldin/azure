variable "name" {
  description = "The name of the container registry webhook."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "registry_name" {
  description = "The name of the container registry."
  type        = string
}

variable "location" {
  description = "The location of the resource."
  type        = string
}

variable "service_uri" {
  description = "The service URI for the webhook."
  type        = string
}

variable "actions" {
  description = "The list of actions that trigger the webhook."
  type        = list(string)
  default     = ["push"]
}

variable "status" {
  description = "The status of the webhook."
  type        = string
  default     = "enabled"
}