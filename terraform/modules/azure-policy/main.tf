
data "azurerm_resource_group" "log_analytics_workspace_rg" {
  name = var.log_analytics_workspace_rg
}

data "azurerm_log_analytics_workspace" "log_analytics_workspace" {
  name                = var.log_analytics_workspace_name
  resource_group_name = var.log_analytics_workspace_rg
}