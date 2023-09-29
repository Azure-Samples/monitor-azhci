terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "3.74.0"
    }
  }
}

# Import Terrafrom module to create Azure Policy and assign it to the Azure Stack HCI Cluster
module "azure_policy" {
  source                        = "./modules/azure-policy"
  subscription_id               = data.azurerm_subscription.current.id
  data_collection_endpoint_name = var.data_collection_endpoint_name
  data_collection_rule_name     = var.data_collection_rule_name
  log_analytics_workspace_name  = var.log_analytics_workspace_name
  log_analytics_workspace_rg    = var.log_analytics_workspace_rg
  user_assigned_identity_name   = var.user_assigned_identity_name
  user_assigned_identity_rg     = var.user_assigned_identity_rg
  policy_assignment_location    = var.policy_assignment_location
}


