data "azurerm_user_assigned_identity" "update_management_user_assigned_identity" {
  name                = var.user_assigned_identity_name
  resource_group_name = var.user_assigned_identity_rg
}

resource "azurerm_subscription_policy_assignment"  "deploy_ama_az_stack_hci_policy" {
  name                 = "deploy_ama_az_stack_hci_policy"
  display_name         = "Deploy AMA on Azure Stack HCI, and associate Data Collection Rule"
  description          = "Deploy Azure Monitoring Agent on Azure Stack HCI cluster and associate with Data Collection Rule"
  location             = var.policy_assignment_location  
  policy_definition_id = azurerm_policy_definition.deploy_ama_dcr_association_policy.id
  subscription_id      = var.subscription_id
  enforce              = false
  identity {
    type         = "UserAssigned"
    identity_ids = [data.azurerm_user_assigned_identity.update_management_user_assigned_identity.id]
  }
  non_compliance_message {
    content = "The Azure Monitoring Agent is not installed on the Azure Stack HCI cluster."
  }
  parameters = jsonencode({
    dataCollectionRuleId = {
      value = azurerm_monitor_data_collection_rule.data_collection_rule.id
    }
  })
}

# Create Azure Policy remediation task
resource "azurerm_subscription_policy_remediation" "deploy_ama_az_stack_hci_policy" {
  name                 = "deploy_ama_az_stack_hci_policy"
  subscription_id      = var.subscription_id
  policy_assignment_id = azurerm_subscription_policy_assignment.deploy_ama_az_stack_hci_policy.id
} 
