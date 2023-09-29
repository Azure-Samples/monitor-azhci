variable "subscription_id" {
  description = "The subscription ID of the Azure Policy"
  type        = string
}

variable "log_analytics_workspace_name" {
  description = "The name of the Log Analytics Workspace"
  type        = string
}

variable "log_analytics_workspace_rg" {
  description = "The resource group name of the Log Analytics Workspace"
  type        = string
}

variable "data_collection_endpoint_name" {
  description = "The resource name of the data collection endpoint"
  type        = string
}

variable "data_collection_rule_name" {
  description = "The resource name of the data collection rule"
  type        = string
}

variable "user_assigned_identity_name" {
  description = "The ID of the User Assigned Identity"
  type        = string
}

variable "user_assigned_identity_rg" {
  description = "The resource group where the User Assigned Identity is located"
  type        = string
}

variable "policy_assignment_location" {
  description = "The location of the Azure Policy Assignment"
  type        = string
}
